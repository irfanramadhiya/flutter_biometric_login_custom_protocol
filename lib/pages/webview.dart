import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  const WebViewPage({super.key});

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    const String webUrl = "https://esafx-stg.esafx.biz/";
    const String deepLinkBaseUrl = "http://esafx.com/";
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.disabled)
      ..setNavigationDelegate(
          NavigationDelegate(onNavigationRequest: (request) {
        if (request.url.startsWith(deepLinkBaseUrl)) {
          _launchUrl(Uri.parse(request.url));
          return NavigationDecision.prevent;
        } else {
          return NavigationDecision.navigate;
        }
      }))
      ..loadRequest(Uri.parse(webUrl));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Center(
            child: Image.asset(
          'assets/images/esafx_logo.png',
          height: 40,
        )),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}
