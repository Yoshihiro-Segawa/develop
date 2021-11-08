import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart' show WidgetsFlutterBinding;
import 'package:webview_flutter/webview_flutter.dart';

class WebScreen extends StatefulWidget {
  @override
  WebScreenState createState() {
    return WebScreenState();
  }
}

class WebScreenState extends State<WebScreen> {
  late WebViewController _controller;

  @override
  Widget build(BuildContext context) {
    print('WebScreenState');
    return Scaffold(
      appBar: AppBar(
        title: Text('利用規約'),
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
    final fileText = await rootBundle.loadString('assets/html/kiyaku.html');
    await _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }
}
