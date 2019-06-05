import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kivaga/Helpers/Helper.dart';
import 'package:kivaga/Objetos/Carro.dart';
import 'package:rxdart/subjects.dart';

class CarrosListController implements BlocBase {
  final carrosRef = Firestore.instance.collection('Carros').reference();
  List<Carro> carros;
  BehaviorSubject<List<Carro>> carrosController =
      new BehaviorSubject<List<Carro>>();
  Stream<List<Carro>> get outCarros => carrosController.stream;

  Sink<List<Carro>> get inCarros => carrosController.sink;

  CarrosListController() {
    getCarros();
  }

  getCarros() {
    if (Helper.localUser != null) {
      carrosRef
          .where('owner', isEqualTo: Helper.localUser.id)
          .getDocuments()
          .then((carrs) {
        if (carros == null) {
          carros = new List<Carro>();
        }
        for (var c in carrs.documents) {
          Carro t = Carro.fromJson(c.data);
          if (carros.contains(t)) {
            carros.add(t);
          }
        }
        inCarros.add(carros);
      }).catchError((err) {
        print('Err: ${err.toString()}');
      });
    }
  }

  void addCarro(Carro c) {
    //TODO Adicionar Carro ao BD
  }

  @override
  void dispose() {
    carrosController.close();
    // TODO: implement dispose
  }
}
