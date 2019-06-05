import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kivaga/Helpers/Helper.dart';
import 'package:kivaga/Objetos/Carro.dart';
import 'package:rxdart/rxdart.dart';

class CadastrarCarroController implements BlocBase {
  final carrosRef = Firestore.instance.collection('Carros').reference();
  BehaviorSubject<Carro> controllerCarro = new BehaviorSubject<Carro>();
  Carro carro;
  Stream<Carro> get outCarro => controllerCarro.stream;

  Sink<Carro> get inCarro => controllerCarro.sink;

  BehaviorSubject<Color> controllerCor = new BehaviorSubject<Color>();

  Stream<Color> get outCor => controllerCor.stream;

  Sink<Color> get inCor => controllerCor.sink;

  CadastrarCarroController({carro}) {
    if (carro == null) {
      carro = new Carro(
          R: 200,
          G: 200,
          B: 200,
          cor: 'Prata',
          modelo: null,
          owner: null,
          placa: null,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          deleted_at: null);
    }
    inCor.add(Color.fromARGB(255, carro.R, carro.G, carro.B));
    this.carro = carro;
    inCarro.add(this.carro);
  }
  UpdateCarColor(Color c) {
    carro.R = c.red;
    carro.G = c.green;
    carro.B = c.blue;
    inCarro.add(carro);
    inCor.add(c);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllerCarro.close();
    controllerCor.close();
  }

  Future<bool> CadastrarCarro(cor, modelo, placa) {
    carro.placa = placa;
    carro.modelo = modelo;
    carro.cor = cor;
    carro.owner = Helper.localUser.id;
    carrosRef.add(carro.toJson()).then((doc) {
      carro.id = doc.documentID;
      carrosRef.document(doc.documentID).updateData(carro.toJson());
    });
  }
}
