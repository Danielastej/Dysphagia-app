import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class HtmlDetailPage extends StatefulWidget {
  final String nadpis;
  final String htmlPath;

  const HtmlDetailPage({
    super.key,
    required this.nadpis,
    required this.htmlPath
  });

  @override
  State<HtmlDetailPage> createState() => _HtmlDetailPageState();
}

class _HtmlDetailPageState extends State<HtmlDetailPage> {
  late final WebViewController _controller;
  @override
  void initState(){
    super.initState();
    _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(Colors.transparent)
    ..loadFlutterAsset(widget.htmlPath);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nadpis, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal[700],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
