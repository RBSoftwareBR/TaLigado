

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';

class PagamentoController implements BlocBase{

BehaviorSubject<String> inteiroController = new BehaviorSubject<String>();

Stream<String> get outInt => inteiroController.stream;

Sink <String> get inInt => inteiroController.sink;
double val = 10.50;
//CONSTRUTOR
PagamentoController(){
  String valor = formatarDinheiro();

  inInt.add(valor);
}

void addContador(){
  this.val = this.val + 10.5;
  String valor = formatarDinheiro();
  inInt.add(valor);
}

String formatarDinheiro(){
  final formatter = new NumberFormat("###,###.###", "pt-br");

  String newText = formatter.format(this.val);
  print(newText);
  return newText;

}

  @override
  void dispose() {
    // TODO: implement dispose
  }

}
  