import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen2 extends StatefulWidget {
  @override
  WebScreenState2 createState() {
    return WebScreenState2();
  }
}

class WebScreenState2 extends State<WebScreen2> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    print('WebScreenState2');
    return Scaffold(
      appBar: AppBar(
        title: Text('プライバシーポリシー'),
      ),
      body: WebView(
        onWebViewCreated: (WebViewController webViewController) async {
          _controller = webViewController;
          await _loadHtmlFromAssets();
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  Future _loadHtmlFromAssets() async {
    WidgetsFlutterBinding.ensureInitialized();
    final fileText = await rootBundle.loadString('assets/html/policy.html');
    await _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
