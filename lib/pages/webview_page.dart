import 'dart:io';
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

/// WebView page.
class WebViewPage extends StatefulWidget {
  const WebViewPage(this.webViewUrl, {Key? key}) : super(key: key);

  /// WebView site url.
  final String webViewUrl;

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

/// [State] of [WebViewPage].
class _WebViewPageState extends State<WebViewPage> {
  @override
  void initState() {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebView')),
      body: SafeArea(
        child: WebView(initialUrl: widget.webViewUrl),
      ),
    );
  }
}
