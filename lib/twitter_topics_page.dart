import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:taligado/Controllers/TwitterController.dart';
import 'package:webview_flutter/webview_flutter.dart';


class TwitterTopicsPage extends StatefulWidget {
  TwitterTopicsPage({Key key}) : super(key: key);

  @override
  _TwitterTopicsPageState createState() {
    return _TwitterTopicsPageState();
  }
}

class _TwitterTopicsPageState extends State<TwitterTopicsPage> {

  TwitterController tc;
  @override
  void initState() {
    super.initState();
    if(tc == null){
      tc = new TwitterController();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      body: Container(height: MediaQuery.of(context).size.height*12,
          child: Container(
            child:WebView(  javascriptMode: JavascriptMode.unrestricted,    onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
                  initialUrl: 'https://twitter.com/explore',
                  ),
          ),
      ),
    );
  }
}
