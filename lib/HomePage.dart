import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart' as Share;
import 'package:taligado/Controllers/NewsController.dart';
import 'package:taligado/selecionar_categorias.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';

import './SearchScreen.dart' as SearchScreen;
import './globalStore.dart' as globalStore;
import 'Controllers/CategoriasController.dart';
import 'Controllers/FavoritosController.dart';
import 'Helpers.dart';
import 'Objetos/Categoria.dart';
import 'Objetos/Noticia.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsController nc;
  final FlutterWebviewPlugin flutterWebviewPlugin = new FlutterWebviewPlugin();
  final TextEditingController _controller = new TextEditingController();

  _hasArticle(Noticia n) {
    for (Noticia f in fc.favoritos) {
      if (n.url == f.url) {
        return true;
      }
    }
    return false;
  }

  _onBookmarkTap(Noticia n) {
    int flag = 0;
    for (Noticia f in fc.favoritos) {
      if (f.url == n.url) {
        fc.removeFavorito(f);
        Scaffold.of(context).showSnackBar(new SnackBar(
          content: new Text('Artigo removido'),
          backgroundColor: Colors.grey[600],
        ));
        flag = 1;
      }
    }
    if (flag != 1) {
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: new Text('Artigo salvo'),
        backgroundColor: Colors.grey[600],
      ));
      fc.addFavorito(n);
    }
    nc.getDestaques();
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
    if (nc == null) {
      nc = NewsController();
    }
    cc.atualizarSelecionada(cc.geral);
    Future.delayed(Duration(seconds: 1)).then((v) {
      if (cc.categorias.length == 0) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => SelecionarCategorias()));
      }
    });
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
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: new TextField(
                controller: _controller,
                onSubmitted: handleTextInputSubmit,
                decoration: new InputDecoration(
                    hintText: 'Procurando noticias?',
                    icon: new Icon(Icons.search)),
              ),
            ),
          ),
        ),
        new Padding(
            padding: new EdgeInsets.all(0.0),
            child: StreamBuilder<List<Categoria>>(
                stream: cc.outCategorias,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  if (snapshot.data.length == 0) {
                    return Container();
                  }
                  return StreamBuilder<Categoria>(
                    stream: cc.outCategoriaSelecionada,
                    builder: (context, selecionada) {
                      if(selecionada.data == null){
                        return Container();
                      }
                      return LimitedBox(
                          maxHeight: MediaQuery.of(context).size.height * .1,
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                print(snapshot.data[index].toString());
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(onTap: (){
                                    cc.atualizarSelecionada(snapshot.data[index]);
                                    nc.FilterByCategoria(snapshot.data[index]);
                                  },
                                    child: Chip(
                                      label: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                            color:  selecionada.data.id ==
                                                    snapshot.data[index].id
                                                ? Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.teal
                                                    : Colors.white
                                                : Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? Colors.white
                                                    : Colors.blue),
                                      ),
                                      avatar: Icon(
                                        snapshot.data[index].icon,
                                        color:  selecionada.data.id ==
                                                snapshot.data[index].id
                                            ? Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.teal
                                                : Colors.white
                                            : Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? Colors.white
                                                : Colors.blue,
                                      ),
                                      backgroundColor:
                                      selecionada.data.id == snapshot.data[index].id
                                              ? Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.blue
                                              : Theme.of(context).brightness ==
                                                      Brightness.dark
                                                  ? Colors.teal
                                                  : Colors.white,
                                    ),
                                  ),
                                );
                              }));
                    }
                  );
                })),
        StreamBuilder<List<Noticia>>(
            stream: nc.outNoticias,
            builder: (context, snap) {
              if (snap.data == null) {
                return Center(child: const CircularProgressIndicator());
              }
              if (snap.data.length == 0) {
                return Center(child: const CircularProgressIndicator());
              }
              print('NOTICIAS AQUI ${snap.data.toString()}');
              return new Expanded(
                  child: new ListView.builder(
                itemCount: snap.data.length,
                padding: new EdgeInsets.all(8.0),
                itemBuilder: (BuildContext context, int index) {
                  print('AQUI NOTICIA ITEM ${snap.data[index]}');
                  return NewsItem(snap.data[index]);
                },
              ));
            })
      ]),
    );
  }

  Widget NewsItem(Noticia n) {
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
                    timeAgo.format(DateTime.parse(n.publishedAt)),
                    style: new TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.all(5.0),
                  child: new Text(
                    n.source.name,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Padding(
                          padding: new EdgeInsets.only(
                              left: 4.0, right: 8.0, bottom: 8.0, top: 8.0),
                          child: new Text(
                            n.title,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        new Padding(
                          padding: new EdgeInsets.only(
                              left: 4.0, right: 4.0, bottom: 4.0),
                          child: new Text(
                            n.description != null ? n.description : '',
                            style: new TextStyle(
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      String url = n.url;
                      if (await canLaunch(url)) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => WebviewScaffold(
                                  clearCache: true,
                                  clearCookies: true,
                                  withLocalStorage: false,
                                  appCacheEnabled: false,
                                  initialChild: Center(
                                      child: CircularProgressIndicator()),
                                  url: url,
                                  appBar: AppBar(
                                    title: Text(n.title),
                                  ),
                                )));
                        flutterWebviewPlugin.onDestroy.listen((_) {
                          if (Navigator.canPop(context)) {
                            Navigator.of(context).pop();
                            flutterWebviewPlugin.dispose();
                            flutterWebviewPlugin.cleanCookies();
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
                    n.urlToImage != null
                        ? new Padding(
                            padding: new EdgeInsets.only(top: 8.0),
                            child: new SizedBox(
                              height: 100.0,
                              width: 100.0,
                              child: new Image.network(
                                n.urlToImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(),
                    new Row(
                      children: <Widget>[
                        new IconButton(
                          icon: buildButtonColumn(Icons.share),
                          onPressed: () {
                            Share.Share.share(n.url);
                          },
                        ),
                        new IconButton(
                          icon: _hasArticle(n)
                              ? buildButtonColumn(Icons.bookmark)
                              : buildButtonColumn(Icons.bookmark_border),
                          onPressed: () {
                            _onBookmarkTap(n);
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
  }
}
