import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';

import './globalStore.dart' as globalStore;
import 'Helpers.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({
    Key key,
    this.searchQuery = "",
  }) : super(key: key);
  final searchQuery;
  @override
  _SearchScreenState createState() =>
      new _SearchScreenState(searchQuery: this.searchQuery);
}

class _SearchScreenState extends State<SearchScreen> {
  _SearchScreenState({this.searchQuery});

  var searchQuery;
  var data;
  bool change = false;
  DataSnapshot snapshot;
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
  final auth = FirebaseAuth.instance;
  final databaseReference = FirebaseDatabase.instance.reference();
  var userDatabaseReference;
  var articleDatabaseReference;

  Future getData() async {
    var response = await http.get(
        Uri.encodeFull('https://newsapi.org/v2/everything?q=' +
            searchQuery +
            '&sortBy=popularity' +
            '&language=${Helpers.language}'),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": "44b3b34cd151438dbc4d098b4c9e6de0"
        });

    var snap = await globalStore.articleDatabaseReference.once();

    if (mounted) {
      this.setState(() {
        data = json.decode(response.body);
        snapshot = snap;
      });
    }
    return "Success!";
  }

  _hasArticle(article) {
    if (snapshot.value != null) {
      var value = snapshot.value;
      int flag = 0;
      if (value != null) {
        value.forEach((k, v) {
          if (v['url'].compareTo(article['url']) == 0) flag = 1;
          return;
        });
        if (flag == 1) return true;
      }
    }
    return false;
  }

  pushArticle(article) {
    articleDatabaseReference.push().set({
      'source': article["source"]["name"],
      'description': article['description'],
      'publishedAt': article['publishedAt'],
      'title': article['title'],
      'url': article['url'],
      'urlToImage': article['urlToImage'],
    });
  }

  _onBookmarkTap(article) {
    if (snapshot.value != null) {
      var value = snapshot.value;
      int flag = 0;
      value.forEach((k, v) {
        if (v['url'].compareTo(article['url']) == 0) {
          flag = 1;
          articleDatabaseReference.child(k).remove();
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Bookmark removido'),
            backgroundColor: Colors.grey[600],
          ));
        }
      });
      if (flag != 1) {
        pushArticle(article);
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Bookmark adicionado'),
          backgroundColor: Colors.grey[600],
        ));
      }
      // if (mounted) {
      this.setState(() {
        change = true;
      });
      // }
    } else {
      pushArticle(article);
    }
  }

  void initState() {
    super.initState();
    this.getData();
  }

  Column buildButtonColumn(IconData icon) {
    return new Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        new Icon(icon),
      ],
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(searchQuery),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: data == null
          ? const Center(child: const CircularProgressIndicator())
          : data["articles"].length < 1
              ? new Padding(
                  padding: new EdgeInsets.only(top: 60.0),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Icon(Icons.error_outline,
                            size: 60.0, color: Colors.redAccent[200]),
                        new Center(
                          child: new Text(
                            "Não foi possivel encontrar nada recionado a: '$searchQuery'",
                            textScaleFactor: 1.5,
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      ]))
              : new ListView.builder(
                  itemCount: data['articles'].length < 51
                      ? data['articles'].length
                      : 50,
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                      child: new Card(
                        elevation: 1.7,
                        child: new Padding(
                          padding: new EdgeInsets.all(10.0),
                          child: new Column(
                            children: [
                              new Row(
                                children: <Widget>[
                                  new Padding(
                                    padding: new EdgeInsets.only(left: 4.0),
                                    child: new Text(
                                      timeAgo.format(DateTime.parse(
                                          data["articles"][index]
                                              ["publishedAt"])),
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                  new Padding(
                                    padding: new EdgeInsets.all(5.0),
                                    child: new Text(
                                      data["articles"][index]["source"]["name"],
                                      style: new TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              new Row(
                                children: [
                                  new Expanded(
                                    child: new GestureDetector(
                                      child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          new Padding(
                                            padding: new EdgeInsets.only(
                                                left: 4.0,
                                                right: 8.0,
                                                bottom: 8.0,
                                                top: 8.0),
                                            child: new Text(
                                              data["articles"][index]["title"],
                                              style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          new Padding(
                                            padding: new EdgeInsets.only(
                                                left: 4.0,
                                                right: 4.0,
                                                bottom: 4.0),
                                            child: new Text(
                                              data["articles"][index]
                                                  ["description"],
                                              style: new TextStyle(
                                                color: Colors.grey[500],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () async {
                                        String url =
                                            data["articles"][index]["url"];
                                        if (await canLaunch(url)) {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (ctx) =>
                                                      WebviewScaffold(
                                                        clearCache: true,
                                                        clearCookies: true,
                                                        withLocalStorage: false,
                                                        appCacheEnabled: false,
                                                        initialChild: Center(
                                                            child:
                                                                CircularProgressIndicator()),
                                                        url: url,
                                                        appBar: AppBar(
                                                            title: Text(
                                                                data["articles"]
                                                                        [index]
                                                                    ['title'])),
                                                      )));
                                          flutterWebviewPlugin.onDestroy
                                              .listen((_) {
                                            if (Navigator.canPop(context)) {
                                              Navigator.of(context).pop();
                                              flutterWebviewPlugin.dispose();
                                              flutterWebviewPlugin
                                                  .cleanCookies();
                                            }
                                          });
                                        } else {
                                          throw 'Não foi possivel abrir a noticia =/ :(';
                                        }
                                      },
                                    ),
                                  ),
                                  new Column(
                                    children: <Widget>[
                                      new Padding(
                                        padding: new EdgeInsets.only(top: 8.0),
                                        child: new SizedBox(
                                          height: 100.0,
                                          width: 100.0,
                                          child: new Image.network(
                                            data["articles"][index]
                                                ["urlToImage"],
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      new Row(
                                        children: <Widget>[
                                          new IconButton(
                                            icon:
                                                buildButtonColumn(Icons.share),
                                            onPressed: () {
                                              Share.share(data["articles"]
                                                  [index]["url"]);
                                            },
                                          ),
                                          new IconButton(
                                            icon: _hasArticle(
                                                    data["articles"][index])
                                                ? buildButtonColumn(
                                                    Icons.bookmark)
                                                : buildButtonColumn(
                                                    Icons.bookmark_border),
                                            onPressed: () {
                                              _onBookmarkTap(
                                                  data["articles"][index]);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
//add try-catch in result query
