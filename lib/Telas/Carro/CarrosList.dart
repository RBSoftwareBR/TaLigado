import 'package:flutter/material.dart';
import 'package:kivaga/Objetos/Carro.dart';
import 'package:kivaga/Telas/Carro/CarrosListController.dart';
import 'package:kivaga/Telas/Dialogs/Dialogs.dart';
import 'package:kivaga/Telas/Home/PaginaPrincipalController.dart';

// ignore: must_be_immutable
class CarrosListPage extends StatefulWidget {
  CarrosListController clc;
  PagesController paginaController;
  CarrosListPage({this.clc, this.paginaController});

  _CarrosListPageState createState() => _CarrosListPageState();
}

class _CarrosListPageState extends State<CarrosListPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: widget.paginaController.outScreenSize,
        builder: (context, snapshot) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: snapshot.hasData
                  ? snapshot.data
                  : MediaQuery.of(context).size.height * .789,
              child: Scaffold(
                  floatingActionButton: FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Icon(
                          Icons.time_to_leave,
                          color: Colors.blue,
                        ),
                        Positioned(
                          child: Icon(
                            Icons.add,
                            color: Colors.green,
                            size: 20,
                          ),
                          top: -5,
                          right: -5,
                        )
                      ],
                    ),
                    onPressed: () {
                      Dialogs().addCarroDlg(context);
                    },
                  ),
                  backgroundColor: Colors.white,
                  body: SingleChildScrollView(
                    child: Container(
                      child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(25.0),
                              child: SizedBox(
                                  //CARREGAMENTO DO PAGAMENTO CONTROLLER
                                  child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Meus Veículos",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    /*Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: StreamBuilder(
                                          stream: widget.pc.outSaldo,
                                          initialData: 0,
                                          builder: (BuildContext context,
                                              AsyncSnapshot snapshot) {
                                            return Text(
                                              snapshot.data.toString(),
                                              style: TextStyle(fontSize: 20),
                                            );
                                          },
                                        ),
                                      ),*/
                                  ],
                                ),
                              )),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * .65,
                                child: StreamBuilder(
                                    stream: widget.clc.outCarros,
                                    builder: (context,
                                        AsyncSnapshot<List<Carro>> carros) {
                                      if (carros.hasData) {
                                        return ListView.separated(
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return CarroItem(
                                                  carros.data[index]);
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(height: 16);
                                            },
                                            itemCount: carros.data.length);
                                      } else {
                                        return Container();
                                      }
                                    })),
                          ]),
                    ),
                  )));
        });
  }

  Widget CarroItem(Carro t) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(
                Icons.time_to_leave,
                size: 60,
                color: Color.fromARGB(255, t.R, t.G, t.B),
              ),
              Text(t.placa, style: TextStyle(fontSize: 22)),
            ],
          ),
          Text(
            t.modelo,
            style: TextStyle(fontSize: 22),
          ),
        ],
      ),
    );
  }

  getTransacaoText(String referencia) {
    switch (referencia) {
      case 'Adicionar Credito':
        return Text('Creditos Adicionados',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic));
      default:
        return Text('Transacao');
    }
  }
}
