import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:imoveis/Helpers/Helper.dart';

Future<Token> getToken() async {
  Stream<String> onCode = await _server();
  String url =
      "https://api.instagram.com/oauth/authorize?client_id=${Helper.INSTAGRAM_APP_ID}&redirect_uri=http://localhost:8585&response_type=code";
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  flutterWebviewPlugin.launch(url);
  final String code = await onCode.first;
  final http.Response response =
      await http.post("https://api.instagram.com/oauth/access_token", body: {
    "client_id": Helper.INSTAGRAM_APP_ID,
    "redirect_uri": "http://localhost:8585",
    "client_secret": Helper.INSTAGRAM_APP_SECRET,
    "code": code,
    "grant_type": "authorization_code"
  });
  flutterWebviewPlugin.close();
  print('Token: ${new Token.fromMap(json.decode(response.body)).toString()}');
  return new Token.fromMap(json.decode(response.body));
}

Future<Stream<String>> _server() async {
  final StreamController<String> onCode = new StreamController();
  HttpServer server =
      await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8585);
  server.listen((HttpRequest request) async {
    final String code = request.uri.queryParameters["code"];
    request.response
      ..statusCode = 200
      ..headers.set("Content-Type", ContentType.HTML.mimeType)
      ..write("<html><h1>You can now close this window</h1></html>");
    await request.response.close();
    await server.close(force: true);
    onCode.add(code);
    await onCode.close();
  });
  return onCode.stream;
}

class Token {
  String access;
  String id;
  String username;
  String full_name;
  String profile_picture;

  Token.fromMap(Map json) {
    access = json['access_token'];
    id = json['user']['id'];
    username = json['user']['username'];
    full_name = json['user']['full_name'];
    profile_picture = json['user']['profile_picture'];
  }

  @override
  String toString() {
    return 'Token{access: $access, id: $id, username: $username, full_name: $full_name, profile_picture: $profile_picture}';
  }
}
