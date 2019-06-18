import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart' as http;

import './ArticleSourceScreen.dart' as ArticleSourceScreen;
import './globalStore.dart' as globalStore;

class SourceLibraryScreen extends StatefulWidget {
  SourceLibraryScreen({Key key}) : super(key: key);

  @override
  _SourceLibraryScreenState createState() => new _SourceLibraryScreenState();
}

class _SourceLibraryScreenState extends State<SourceLibraryScreen> {
  DataSnapshot snapshot;
  var sources;
  bool change = false;
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();

  Future getData() async {
    var libSources = await http
        .get(Uri.encodeFull('https://newsapi.org/v2/sources?'), headers: {
      "Accept": "application/json",
      "X-Api-Key": "44b3b34cd151438dbc4d098b4c9e6de0"
    });

    var snap = await globalStore.articleSourcesDatabaseReference.once();
    if (mounted) {
      this.setState(() {
        sources = json.decode(libSources.body);
        snapshot = snap;
      });
    }
    return "Success!";
  }

  _hasSource(id) {
    if (snapshot.value != null) {
      var value = snapshot.value;
      int flag = 0;
      if (value != null) {
        value.forEach((k, v) {
          if (v['id'].compareTo(id) == 0) {
            flag = 1;
          }
        });
        if (flag == 1) return true;
      }
    }
    return false;
  }

  pushSource(name, id) {
    globalStore.articleSourcesDatabaseReference.push().set({
      'name': name,
      'id': id,
    });
  }

  _onAddTap(name, id) {
    if (snapshot.value != null) {
      var value = snapshot.value;
      int flag = 0;
      value.forEach((k, v) {
        if (v['id'].compareTo(id) == 0) {
          flag = 1;
          Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('$name Removido'),
            backgroundColor: Colors.grey[600],
          ));
          globalStore.articleSourcesDatabaseReference.child(k).remove();
        }
      });
      if (flag != 1) {
        Scaffold.of(context).showSnackBar(new SnackBar(
            content: new Text('$name Adicionado'),
            backgroundColor: Colors.grey[600]));
        pushSource(name, id);
      }
    } else {
      pushSource(name, id);
    }
    this.getData();
    if (mounted) {
      this.setState(() {
        change = true;
      });
    }
  }

  Future<CircleAvatar> _loadAvatar(var url) async {
    print("https://i.olsh.me/allicons.json?url=" + url + "&size=120");
    if (url == "http://www.bleacherreport.com") {
      return new CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: new NetworkImage(
            "http://static-assets.bleacherreport.com/favicon.ico"),
        radius: 40.0,
      );
    }
    try {
      var r = await http
          .get("https://i.olsh.me/allicons.json?url=" + url + "&size=120");
      var j = json.decode(r.body);
      return new CircleAvatar(
        backgroundColor: Colors.transparent,
        backgroundImage: new CachedNetworkImageProvider(j['icons'][0]['url']),
        radius: 40.0,
      );
    } catch (Exception) {
      return new CircleAvatar(
        child: new Icon(Icons.library_books),
        radius: 40.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      body: sources == null
          ? const Center(child: const CircularProgressIndicator())
          : new GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, mainAxisSpacing: 25.0),
              padding: const EdgeInsets.all(10.0),
              itemCount: sources == null ? 0 : sources['sources'].length,
              itemBuilder: (BuildContext context, int index) {
                print(
                  'AQUI CAPETA' + sources['sources'][index]['name'],
                );
                return new GridTile(
                  footer: new Text(
                    sources['sources'][index]['name']
                            .toString()
                            .contains('Google News')
                        ? sources['sources'][index]['name']
                            .toString()
                            .replaceAll('Google News', 'GN')
                        : sources['sources'][index]['name'].toString(),
                    maxLines: 2,
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                  child: new Container(
                    height: 500.0,
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: new GestureDetector(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          new SizedBox(
                            height: 100.0,
                            width: 100.0,
                            child: new Row(
                              children: <Widget>[
                                new Stack(
                                  children: <Widget>[
                                    new SizedBox(
                                      child: new Container(
                                        child: FutureBuilder(
                                          future: _loadAvatar(
                                              sources['sources'][index]['url']),
                                          builder: (context,
                                              AsyncSnapshot<Widget> snap) {
                                            return snap.hasData
                                                ? snap.data
                                                : new CircleAvatar(
                                                    child: new Icon(
                                                        Icons.library_books),
                                                    radius: 40.0,
                                                  );
                                            ;
                                          },
                                        ),
                                        padding: const EdgeInsets.only(
                                            left: 10.0, top: 12.0, right: 10.0),
                                      ),
                                    ),
                                    new Positioned(
                                      right: 0.0,
                                      child: IconButton(
                                        icon: _hasSource(
                                                sources['sources'][index]['id'])
                                            ? new Icon(
                                                Icons.check_circle,
                                                color: Colors.greenAccent[700],
                                              )
                                            : new Icon(
                                                Icons.add_circle_outline,
                                                color: Colors.grey[500],
                                              ),
                                        onPressed: () {
                                          _onAddTap(
                                              sources['sources'][index]['name'],
                                              sources['sources'][index]['id']);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (_) =>
                                    new ArticleSourceScreen.ArticleSourceScreen(
                                      sourceId: sources['sources'][index]['id'],
                                      sourceName: sources['sources'][index]
                                          ['name'],
                                      isCategory: false,
                                    )));
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
