import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kivaga/Helpers/Helper.dart';
import 'package:rxdart/subjects.dart';

import '../../Objetos/Transacao.dart';

class PagamentoController implements BlocBase {
  final transacoesRef = Firestore.instance.collection('Transacoes').reference();
  List<Transacao> transacoes;
  BehaviorSubject<List<Transacao>> transacoesController =
      new BehaviorSubject<List<Transacao>>();
  Stream<List<Transacao>> get outTransacoes => transacoesController.stream;

  Sink<List<Transacao>> get inTransacoes => transacoesController.sink;

  BehaviorSubject<String> saldoController = new BehaviorSubject<String>();

  Stream<String> get outSaldo => saldoController.stream;

  Sink<String> get inSaldo => saldoController.sink;
//CONSTRUTOR
  PagamentoController() {
    getTransacoes();
  }

  getTransacoes() {
    if (Helper.localUser != null) {
      print('BUSCANDO TRANSACOES ${Helper.localUser.id}');
      transacoesRef
          .where('adquirente', isEqualTo: Helper.localUser.id)
          .getDocuments()
          .then((compras) {
        print('Buscou Compras');
        if (transacoes == null) {
          transacoes = new List<Transacao>();
        }
        for (var c in compras.documents) {
          Transacao t = Transacao.fromJson(c.data);
          if (!transacoes.contains(t)) {
            transacoes.add(t);
          }
        }
        transacoes.sort((a, b) => b.created_at.millisecondsSinceEpoch
            .compareTo(b.created_at.millisecondsSinceEpoch));
        inTransacoes.add(transacoes);
        formatarDinheiro(transacoes);
      }).catchError((err) {
        print('Err: ${err.toString()}');
      });

      transacoesRef
          .where('beneficiario', isEqualTo: Helper.localUser.id)
          .getDocuments()
          .then((recebimentos) {
        if (transacoes == null) {
          transacoes = new List<Transacao>();
        }
        for (var c in recebimentos.documents) {
          Transacao t = Transacao.fromJson(c.data);
          if (!transacoes.contains(t)) {
            transacoes.add(t);
          }
        }
        transacoes.sort((a, b) => b.created_at.millisecondsSinceEpoch
            .compareTo(a.created_at.millisecondsSinceEpoch));
        inTransacoes.add(transacoes);
        formatarDinheiro(transacoes);
      }).catchError((err) {
        print('Err: ${err.toString()}');
      });
    } else {
      print('USER NULO');
    }
  }

  void addCredito() {
    if (Helper.localUser != null) {
      Transacao t = new Transacao(
          adquirente: 'Kivaga',
          beneficiario: Helper.localUser.id,
          created_at: DateTime.now(),
          updated_at: DateTime.now(),
          deleted_at: null,
          referencia: 'Adicionar Credito',
          valor: 10);
      transacoesRef.add(t.toJson()).then((d) {
        t.id = d.documentID;
        transacoesRef.document(d.documentID).updateData(t.toJson());
        transacoes.add(t);
        inTransacoes.add(transacoes);
        formatarDinheiro(transacoes);
      }).catchError((err) {
        print('Err: ${err.toString()}');
      });
    }
  }

  String formatarDinheiro(List<Transacao> transacoes) {
    double saldo = 0;
    for (Transacao t in transacoes) {
      saldo = t.beneficiario == Helper.localUser.id
          ? saldo += t.valor
          : saldo -= t.valor;
    }
    print('Entrou AQUI DINHEIRO ${saldo} ${transacoes.length}');
    inSaldo.add(saldo.toStringAsFixed(2).replaceAll('.', ','));
    return saldo.toStringAsFixed(2).replaceAll('.', ',');
  }

  @override
  void dispose() {
    saldoController.close();
    transacoesController.close();
    // TODO: implement dispose
  }
}
