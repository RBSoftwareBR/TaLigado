import 'dart:convert';

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
        onPressed: () {
          pc.addContador();
        },
      ),
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: SizedBox(
                  //CARREGAMENTO DO PAGAMENTO CONTROLLER
                  child: StreamBuilder(
                    stream: pc.outInt,
                    initialData: 0,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Meus créditos",
                              style: TextStyle(fontSize: 20),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data.toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                //Aqui centraliza no meio da tela
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height * .75,
                child: Center(
                  child: Text("Transações",style: TextStyle(fontSize: 25,color: Colors.blueGrey),),
                )
              ),
              

              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .75,
                child: ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text("Compra créditos"),
                        subtitle: Text("20/06/2019"),
                        trailing: Text("20,00"),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(height: 16);
                    },
                    itemCount: 10),
              )
            ]),
      ),
    );
  }
}
