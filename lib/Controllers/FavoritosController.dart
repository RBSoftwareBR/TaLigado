import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import '../globalStore.dart' as globalStore;
import '../Objetos/Noticia.dart';

class FavoritosController extends BlocBase{
  BehaviorSubject<List<Noticia>> controllerFavoritos = BehaviorSubject<List<Noticia>>();
  Stream<List<Noticia>> get outFavoritos => controllerFavoritos.stream;
  Sink<List<Noticia>> get inFavoritos => controllerFavoritos.sink;
  List<Noticia> favoritos = new List();
  CollectionReference FavoritosRef = Firestore.instance.collection('Favoritos').document(globalStore.user.uid).collection('Favoritos').reference();

  FavoritosController(){
    FavoritosRef.snapshots().listen((v){
      favoritos =new List();
      for(var i in v.documents){
        Noticia n = Noticia.fromJson(i.data);
        favoritos.add(n);
      }
      inFavoritos.add(favoritos);
    }).onError((err){
      print('Erro ao buscar Favoritos ${err.toString()}');
    });
  }
  
  addFavorito(Noticia n){
    FavoritosRef.add(n.toJson()).then((v){
      print('Noticia salva com sucesso');
    }).catchError((err){
      print('Erro ao salvar noticia favorita ${err.toString()}');
    });
  }
  
  removeFavorito(Noticia n){
    FavoritosRef.where('url',isEqualTo: n.url).getDocuments().then((v){
      for(var i in v.documents){
        FavoritosRef.document(i.documentID).delete().then((v){
          print('Deletado com sucesso!');
        });
      }
    });
  }
  @override
  void dispose() {
    controllerFavoritos.close();
  }
}
FavoritosController fc = FavoritosController();