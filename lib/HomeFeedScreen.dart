import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart' as Share;
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';

import './SearchScreen.dart' as SearchScreen;
import './globalStore.dart' as globalStore;
import 'Helpers.dart';

class HomeFeedScreen extends StatefulWidget {
  HomeFeedScreen({Key key}) : super(key: key);

  @override
  _HomeFeedScreenState createState() => new _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  var data;
  var newsSelection = "google-news-br";
  DataSnapshot snapshot;
  var snapSources;
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
  final TextEditingController _controller = new TextEditingController();
  Future getData() async {
    snapSources = await globalStore.articleSourcesDatabaseReference.once();
    var snap = await globalStore.articleDatabaseReference.once();
    if (snapSources.value != null) {
      newsSelection = '';
      snapSources.value.forEach((key, source) {
        newsSelection = newsSelection + source['id'] + ',';
      });
    }
    print('https://newsapi.org/v2/top-headlines?country=br');
    var response = await http.get(
        Uri.encodeFull('https://newsapi.org/v2/top-headlines?country=br'
            /*'&language=${Helpers.language}'*/
            ),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": "44b3b34cd151438dbc4d098b4c9e6de0"
        });
    print('AQUI BODY' + response.body.toString());
    var localData = json.decode(response.body);
    /*if (localData != null && localData["articles"] != null) {
      localData["articles"].sort((a, b) => DateTime(a["publishedAt"]) != null &&
              DateTime(b["publishedAt"]) != null
          ? DateTime(b["publishedAt"]).isBefore(DateTime(a["publishedAt"]))
          : null);
    }*/
    // if (mounted) {
    this.setState(() {
      data = localData;
      snapshot = snap;
    });
    // }
    return "Success!";
  }

  _hasArticle(article) {
    if (snapshot.value != null) {
      var value = snapshot.value;
      int flag = 0;
      if (value != null) {
        value.forEach((k, v) {
          if (v['url'].compareTo(article['url']) == 0) {
            flag = 1;
            return;
          }
        });
        if (flag == 1) return true;
      }
    }
    return false;
  }

  pushArticle(article) {
    globalStore.articleDatabaseReference.push().set({
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
          globalStore.articleDatabaseReference.child(k).remove();
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Artigo removido'),
            backgroundColor: Colors.grey[600],
          ));
        }
      });
      if (flag != 1) {
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Artigo salvo'),
          backgroundColor: Colors.grey[600],
        ));
        pushArticle(article);
      }
    } else {
      pushArticle(article);
    }
    this.getData();
  }

  _onRemoveSource(id, name) {
    if (snapSources != null) {
      snapSources.value.forEach((key, source) {
        if (source['id'].compareTo(id) == 0) {
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('Você tem certeza que deseja remover $name?'),
            backgroundColor: Colors.grey[600],
            duration: new Duration(seconds: 3),
            action: new SnackBarAction(
                label: 'Sim',
                onPressed: () {
                  globalStore.articleSourcesDatabaseReference
                      .child(key)
                      .remove();
                  Scaffold.of(context).showSnackBar(new SnackBar(
                      content: new Text('$name removido'),
                      backgroundColor: Colors.grey[600]));
                }),
          ));
        }
      });
      this.getData();
    }
  }

  void handleTextInputSubmit(var input) {
    if (input != '') {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (_) =>
                  new SearchScreen.SearchScreen(searchQuery: input)));
    }
  }

  @override
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

  Future ensureLogIn(BuildContext context) async {
    await globalStore.ensureLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Column(children: <Widget>[
        new Padding(
          padding: new EdgeInsets.all(0.0),
          child: new PhysicalModel(
            color: Helpers.brightness != null
                ? Helpers.brightness ? Colors.black : Colors.white
                : Colors.white,
            elevation: 3.0,
            child: new TextField(
              controller: _controller,
              onSubmitted: handleTextInputSubmit,
              decoration: new InputDecoration(
                  hintText: 'Procurando noticias?',
                  icon: new Icon(Icons.search)),
            ),
          ),
        ),
        new Expanded(
          child: data == null
              ? const Center(child: const CircularProgressIndicator())
              : data["articles"].length != 0
                  ? new ListView.builder(
                      itemCount: data == null ? 0 : data["articles"].length,
                      padding: new EdgeInsets.all(8.0),
                      itemBuilder: (BuildContext context, int index) {
                        return new Card(
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
                                        data["articles"][index]["source"]
                                            ["name"],
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
                                                data["articles"][index]
                                                    ["title"],
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
                                                          withLocalStorage:
                                                              false,
                                                          appCacheEnabled:
                                                              false,
                                                          initialChild: Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                          url: url,
                                                          appBar: AppBar(
                                                            title: Text(
                                                                data["articles"]
                                                                        [index]
                                                                    ['title']),
                                                          ),
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
                                          padding:
                                              new EdgeInsets.only(top: 8.0),
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
                                              icon: buildButtonColumn(
                                                  Icons.share),
                                              onPressed: () {
                                                Share.Share.share(
                                                    data["articles"][index]
                                                        ["url"]);
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
                                            /*  new IconButton(
                                              icon: buildButtonColumn(
                                                  Icons.not_interested),
                                              onPressed: () {
                                                _onRemoveSource(
                                                    data["articles"][index]
                                                        ["source"]["id"],
                                                    data["articles"][index]
                                                        ["source"]["name"]);
                                              },
                                            ),*/
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ), ////
                          ),
                        );
                      },
                    )
                  : new Center(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Icon(Icons.chrome_reader_mode,
                              color: Colors.grey, size: 60.0),
                          new Text(
                            "Nenhum artigo salvo",
                            style: new TextStyle(
                                fontSize: 24.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
        )
      ]),
    );
  }
}
