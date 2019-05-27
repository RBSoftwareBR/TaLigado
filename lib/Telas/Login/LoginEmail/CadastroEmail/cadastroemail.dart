import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:kivaga/Telas/Login/LoginEmail/CadastroEmail/cadastroemailController.dart';

class CadastroEmail extends StatelessWidget {
  CadastroEmailController cec;
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

  static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    cec = new CadastroEmailController();
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text('Cadastrar'),
        ),
        body: ListView(
          children: <Widget>[
            buildUserForm(User.Empty(), cec),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
            ),
            MaterialButton(
                onPressed: () {
                  scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: Text('Registrando')));

                  cec.outUser.first.then((u) {
                    print(u.toString());
                    cec.registerUser(u).then((value) {
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

  buildUserForm(User data, CadastroEmailController cec) {
    return Column(children: <Widget>[
      Padding(padding: ei),
      new Padding(
        padding: ei,
        child: TextFormField(
          autovalidate: true,
          textCapitalization: TextCapitalization.words,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Nome';
            } else {
              data.nome = value;
              cec.inUser.add(data);
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
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Email';
            } else {
              if (value.contains('@')) {
                data.email = value;
                cec.inUser.add(data);
              } else {
                return 'Email Invalido';
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.email,
                color: pageColor,
              ),
              /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),*/
              hintText: 'contatorbsoftware@gmail.com',
              labelText: 'Email',
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
          autovalidate: true,
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
                cec.inUser.add(data);
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
          autovalidate: true,
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
                cec.inUser.add(data);
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
      new Padding(
        padding: ei,
        child: TextFormField(
          autovalidate: true,
          controller: controllerSenha,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher a Senha';
            } else {
              if (value.length < 6) {
                return 'Senha é Muito Curta!';
              } else {
                var s = value.split('/');
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: pageColor,
              ),
              /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),*/
              hintText: 'Maggie1723',
              labelText: 'Senha',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
      new Padding(
        padding: ei,
        child: TextFormField(
          autovalidate: true,
          obscureText: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher a Senha';
            } else {
              if (value.length < 6) {
                return 'Senha é Muito Curta!';
              } else {
                if (value == controllerSenha.text) {
                  data.senha = value;
                  cec.inUser.add(data);
                } else {
                  return 'Senhas não conferem';
                }
              }
            }
          },
          decoration: InputDecoration(
              icon: Icon(
                Icons.lock_outline,
                color: pageColor,
              ),
              /*border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),*/
              hintText: 'Maggie1723',
              labelText: 'Repita a Senha',
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.0,
                  fontStyle: FontStyle.italic)),
        ),
      ),
    ]);
  }
}
