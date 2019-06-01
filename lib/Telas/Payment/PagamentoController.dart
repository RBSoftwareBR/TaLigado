

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class PagamentoController implements BlocBase{

BehaviorSubject<int> inteiroController = new BehaviorSubject<int>();

Stream<int> get outInt => inteiroController.stream;

Sink <int> get inInt => inteiroController.sink;
int val = 1;
//CONSTRUTOR
PagamentoController(){

  inInt.add(this.val);
}

void addContador(){
  this.val = this.val + 1;
  inInt.add(this.val);
}
  @override
  void dispose() {
    // TODO: implement dispose
  }

}
  