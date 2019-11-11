import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:taligado/Objetos/Categoria.dart';
import '../globalStore.dart' as globalStore;
import '../Objetos/Noticia.dart';

class NewsController extends BlocBase{
  BehaviorSubject<List<Noticia>> controllerNoticias = BehaviorSubject<List<Noticia>>();
  Stream<List<Noticia>> get outNoticias =>controllerNoticias.stream;
  Sink<List<Noticia>> get inNoticias => controllerNoticias.sink;
  List<Noticia> noticias;
  var newsSelection = "google-news-br";



  NewsController(){
  getDestaques();
  }

  getDestaques(){
    http.get(
        Uri.encodeFull('https://newsapi.org/v2/top-headlines?country=br'
                       /*'&language=${Helpers.language}'*/
                       ),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": "44b3b34cd151438dbc4d098b4c9e6de0"
        }).then((response){
      noticias = new List();
      var localData = json.decode(response.body);
      for(var i in localData['articles']){
        Noticia n = Noticia.fromJson(i);
        noticias.add(n);
      }
      inNoticias.add(noticias);
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    controllerNoticias.close();
  }

  void FilterByCategoria(Categoria data) {
    http.get(
        Uri.encodeFull('https://newsapi.org/v2/top-headlines?country=br&category=' +
                           data.id
                       ),
        headers: {
          "Accept": "application/json",
          "X-Api-Key": "44b3b34cd151438dbc4d098b4c9e6de0"
        }).then((response){
      noticias = new List();
      var localData = json.decode(response.body);
      for(var i in localData['articles']){
        Noticia n = Noticia.fromJson(i);
        noticias.add(n);
      }
      inNoticias.add(noticias);
    });
  }
}