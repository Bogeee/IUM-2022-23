import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RegisterView extends StatefulWidget  {

  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  @override
  Widget build(BuildContext context) {
    // Non funziona ancora, sto vedendo la documentazione
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
    webCtl.loadRequest(Uri.parse('https://www.google.com'));
 
    // return WebViewWidget(controller: webCtl);
    return Scaffold(
      body: WebViewWidget(controller: webCtl,)
    );
  }
}