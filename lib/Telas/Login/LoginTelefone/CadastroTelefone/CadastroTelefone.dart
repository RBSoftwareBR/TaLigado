import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:kivaga/Telas/Login/LoginTelefone/CadastroTelefone/CadastroTelefoneController.dart';

class CadastroTelefone extends StatelessWidget {
  CadastroTelefoneController ctc;
  final _formKey = GlobalKey<FormState>();
  Color pageColor = Colors.blue;

  var controllercpf =
      new MaskedTextController(text: '', mask: '000.000.000-00');
  var controllerTelefone =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');
  var controllerDataNascimento =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerDataExpedicao =
      new MaskedTextController(text: '', mask: '00/00/0000');
  var controllerSenha = new TextEditingController(text: '');
  EdgeInsets ei = EdgeInsets.fromLTRB(10.0, 3.0, 15.0, 3.0);
  var controllerCEP = new MaskedTextController(text: '', mask: '00000-000');
  var controllerCidade = new TextEditingController(text: '');
  var controllerEstado = new TextEditingController(text: '');
  var controllerEndereco = new TextEditingController(text: '');
  var controllerBairro = new TextEditingController(text: '');
  var controllerNome = new TextEditingController(text: '');
  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ctc = new CadastroTelefoneController();
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Cadastrar'),
        ),
        body: ListView(
          children: <Widget>[
            buildUserForm(User.Empty(), ctc),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            MaterialButton(
                onPressed: () {
                  scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: Text('Registrando')));

                  var s = controllerDataNascimento.text.split('/');
                  User u = new User(
                      celular: controllerTelefone.text,
                      nome: controllerNome.text,
                      cpf: controllercpf.text,
                      data_nascimento: new DateTime(
                          int.parse(s[2]), int.parse(s[1]), int.parse(s[0])));

                  ctc.registerUser(u).then((value) {
                    if (value == 0) {
                      scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Registrado Com Sucesso')));

                      Future.delayed(Duration(seconds: 2)).then((v) {
                        Navigator.of(context).pop();
                      });
                    } else if (value == 1) {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'Erro ao efetuar Cadastro: Telefone já cadastrado')));
                    } else {
                      scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text(
                              'Erro ao efetuar Cadastro: Tente novamente mais tarde')));
                    }
                  });
                },
                child: Container(
                    width: MediaQuery.of(context).size.width * .9,
                    height: MediaQuery.of(context).size.height * .2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * .9,
                          height: MediaQuery.of(context).size.height * .08,
                          decoration: BoxDecoration(
                              color: pageColor,
                              borderRadius: BorderRadiusDirectional.all(
                                  Radius.circular(10))),
                          child: Center(
                              child: Text(
                            'Cadastrar',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          )),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        Text(
                          'Ao clicar em cadastrar você está concordando com nossos termos de uso',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 14),
                        )
                      ],
                    ))),
          ],
        ));
  }

  buildUserForm(User data, CadastroTelefoneController ctc) {
    return Column(children: <Widget>[
      Padding(padding: ei),
      new Padding(
        padding: ei,
        child: TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: controllerNome,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Nome';
            } else {
              data.nome = value;
              ctc.inUser.add(data);
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.account_circle,
                color: pageColor,
              ),
              /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),*/
              hintText: 'João da Silva',
              labelText: 'Nome Completo',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          controller: controllerTelefone,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Celular';
            } else {
              if ('(00) 0 0000-0000'.length != value.length) {
                return 'Celular Invalido';
              } else {
                data.celular = value;
                ctc.inUser.add(data);
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.phone_android,
                color: pageColor,
              ),
              /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),*/
              hintText: '(00)0 0000-0000',
              labelText: 'Celular',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          controller: controllerDataNascimento,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher a Data de Nascimento';
            } else {
              if (value.length != '00/00/0000'.length) {
                return 'Data de Nascimento Invalida!';
              } else {
                var s = value.split('/');
                data.data_nascimento = new DateTime(
                    int.parse(s[2]), int.parse(s[1]), int.parse(s[0]));
                print('Data Nascimento ' +
                    data.data_nascimento.toIso8601String());
                ctc.inUser.add(data);
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.date_range,
                color: pageColor,
              ),
              /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),*/
              labelText: 'Data de Nascimento',
              hintText: 'dd/mm/aaaa',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          controller: controllercpf,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o CPF';
            } else {
              if (value.length != '000.000.000-00'.length) {
                return 'CPF Invalido';
              } else {
                data.cpf = value;
                ctc.inUser.add(data);
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.account_balance_wallet,
                color: pageColor,
              ),
              /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),*/
              labelText: 'CPF',
              hintText: '000.000.000-00',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
    ]);
  }
}
