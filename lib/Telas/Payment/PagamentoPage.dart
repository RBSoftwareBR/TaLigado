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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,

      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          pc.addContador();
        },
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Center(
              child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .75,
            
            //CARREGAMENTO DO PAGAMENTO CONTROLLER
            child: StreamBuilder(
              stream: pc.outInt,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                return Center(
                  child: Text(snapshot.data.toString(),style: TextStyle(fontSize: 20),),
                );
              },
            ),
          ))
        ]),
      ),
    );
  }
}
