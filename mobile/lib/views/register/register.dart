import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:proj/models/register_info.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterView extends StatefulWidget  {

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    WebViewController webCtl = WebViewController();
    webCtl.setJavaScriptMode(JavaScriptMode.unrestricted);
    webCtl.setBackgroundColor(Colors.white);
    webCtl.setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {
          print(error);
        },
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    );

    webCtl.loadFlutterAsset('assets/register/register.html');
    webCtl.addJavaScriptChannel('formDataChannel', onMessageReceived: (JavaScriptMessage message) async {
      var data = json.decode(message.message);
      if(data is !bool) {
        final register = await registerUser(data['first-name'], data['last-name'], data['email'], data['password']);
        var script = "";
        if(register.success) {
          script = "showResult(\"Registrazione avvenuta con successo. Verrai rediretto alla pagina di login.\");";
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacementNamed(context, '/login');
          });
        } else if(register.message == "") {
          script = "showError(\"Errore durante la registrazione. Riprovare\");";
        } else {
          script = "showError(\"${register.message}\");";
        }
        webCtl.runJavaScript(script);
      }
    });

    return Scaffold(
      body: WebViewWidget(controller: webCtl)
    );
  }
}