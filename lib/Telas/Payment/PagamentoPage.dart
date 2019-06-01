import 'package:flutter/material.dart';
import 'package:kivaga/Telas/Payment/PagamentoController.dart';


class PagamentoPage extends StatefulWidget {
  PagamentoPage({Key key}) : super(key: key);

  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
  PagamentoController pc;

  @override
  Widget build(BuildContext context) {
    pc = new PagamentoController();
    return Container(
       child: Row(
         children: <Widget>[
           Center(
             child: StreamBuilder(
               stream: pc.outInt ,
               initialData: 0,
               builder: (BuildContext context, AsyncSnapshot<int> snapshot){
                 return Container(
                   child: Text(snapshot.toString()),
                 );
               },
             ),
           )
         ],
       ),
    );
  }
}