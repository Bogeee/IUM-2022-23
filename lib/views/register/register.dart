import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

class RegisterView extends StatelessWidget  {

  const RegisterView({super.key});
  
@override
  Widget build(BuildContext context) {
    // Non funziona ancora, sto vedendo la documentazione
    // WebViewController webCtl = WebViewController();
    // webCtl.setJavaScriptMode(JavaScriptMode.unrestricted);
    // webCtl.loadHtmlString("www.google.com");

    // return WebViewWidget(controller: webCtl);
    return const Scaffold(
      body: Center(
        child: Text('ciao'),
      )
    );
  }
}