

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class PagamentoController implements BlocBase{

BehaviorSubject<int> inteiroController = new BehaviorSubject<int>();

Stream<int> get outInt => inteiroController.stream;

Sink <int> get inInt => inteiroController.sink;

//CONSTRUTOR
PagamentoController(){
  int val = 1;

  inInt.add(val);
}

addContador(){

  inInt.add(1);
}
  @override
  void dispose() {
    // TODO: implement dispose
  }

}
  