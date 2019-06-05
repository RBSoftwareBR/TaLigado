import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kivaga/Objetos/Transacao.dart';
import 'package:kivaga/Telas/Home/PaginaPrincipalController.dart';
import 'package:kivaga/Telas/Payment/PagamentoController.dart';

class PagamentoPage extends StatefulWidget {
  PagamentoController pc;
  PagesController paginaController;
  PagamentoPage({this.pc, this.paginaController});

  _PagamentoPageState createState() => _PagamentoPageState();
}

class _PagamentoPageState extends State<PagamentoPage> {
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
                    child: Stack(
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    onPressed: () {
                      widget.pc.addCredito();
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
                                      "Meus créditos",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Padding(
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
                                    ),
                                  ],
                                ),
                              )),
                            ),
                            SizedBox(
                                //Aqui centraliza no meio da tela
                                //width: MediaQuery.of(context).size.width,
                                //height: MediaQuery.of(context).size.height * .75,
                                child: Center(
                              child: Text(
                                "Transações",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.blueGrey),
                              ),
                            )),
                            Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * .6,
                                child: StreamBuilder(
                                    stream: widget.pc.outTransacoes,
                                    builder: (context,
                                        AsyncSnapshot<List<Transacao>>
                                            transacoes) {
                                      if (transacoes.hasData) {
                                        return ListView.separated(
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return TransacaoItem(
                                                  transacoes.data[index]);
                                            },
                                            separatorBuilder: (context, index) {
                                              return Divider(height: 16);
                                            },
                                            itemCount: transacoes.data.length);
                                      } else {
                                        return Container();
                                      }
                                    })),
                          ]),
                    ),
                  )));
        });
  }

  Widget TransacaoItem(Transacao t) {
    String data = new DateFormat.yMd().add_Hm().format(t.created_at);
    return ListTile(
      title: getTransacaoText(t.referencia),
      subtitle: Text(data),
      trailing: Text('R\$ ${t.valor.toStringAsFixed(2)}'),
    );
  }

  getTransacaoText(String referencia) {
    switch (referencia) {
      case 'Adicionar Credito':
        return Text('Creditos Adicionados',
            style: TextStyle(color: Colors.green, fontStyle: FontStyle.italic));
      default:
        return Text('Transacao');
    }
  }
}
