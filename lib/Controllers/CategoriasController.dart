import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:taligado/Objetos/Categoria.dart';
import '../globalStore.dart' as globalStore;
import '../categoriesList.dart' as categoriesList;


class CategoriasController extends BlocBase{
  BehaviorSubject<List<Categoria>> controllerCategoria = BehaviorSubject<List<Categoria>>();
  Stream<List<Categoria>> get outCategorias =>controllerCategoria.stream;
  Sink<List<Categoria>> get inCategorias => controllerCategoria.sink;
  List<Categoria> categorias = new List();
  CollectionReference categoriasRef = Firestore.instance.collection('Categorias').document(globalStore.user.uid).collection('Categorias').reference();
 Categoria geral = Categoria(
  id: "general",
  name: "Geral",
  icon: Icons.people,
  color: Colors.cyan
  );
Categoria selecionada;
  BehaviorSubject<Categoria> controllerCategoriaSelecionada = BehaviorSubject<Categoria>();
  Stream<Categoria> get outCategoriaSelecionada =>controllerCategoriaSelecionada.stream;
  Sink<Categoria> get inCategoriaSelecionada => controllerCategoriaSelecionada.sink;
  CategoriasController(){
    selecionada = geral;
    inCategoriaSelecionada.add(selecionada);
    categoriasRef.snapshots().listen((v){
      categorias = new List();
      categorias.add(geral);
      for(var i in v.documents){
        for(Categoria cat in categoriesList.list) {
          if(cat.id == i.data['id']) {
            Categoria c = cat;
            print('ADICIONOU CATEGORIA ${c.toString()}');
            categorias.add(c);
          }
        }
      }
      inCategorias.add(categorias);
    });
  }

  addCategoria(Categoria c){
    categoriasRef.document(c.id).setData({'id': c.id}).then((v){
      print('Categoria favoritada com sucesso!');
    }).catchError((err){
      print('Erro ao salvar Categoria: ${err.toString()}');
    });
  }

  removeCategoria(Categoria c){
    categoriasRef.document(c.id).delete().then((v){
      print('Categoria Removida com sucesso!');
    }).catchError((err){
      print('Erro ao remover Categoria: ${err.toString()}');
    });
  }


  @override
  void dispose() {
    controllerCategoria.close();
  }

  void atualizarSelecionada(Categoria data) {
    selecionada = data;
    inCategoriaSelecionada.add(selecionada);}
}

CategoriasController cc = CategoriasController();