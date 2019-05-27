import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EsqueceuSenha extends StatelessWidget {
  Color pageColor = Colors.blue;
    EdgeInsets ei = EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0);
     final FirebaseAuth _auth = FirebaseAuth.instance;
       var controllerEmail = new TextEditingController(text: '');
         static final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('EsqueceuSenha'),
      ),
      body: Center(
        child: Column(crossAxisAlignment:  CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
           new Padding(
        padding: ei,
        child: TextFormField(controller: controllerEmail,
          validator: (value) {
            if (value.isEmpty) {
              return 'É Nescessario preencher o Email';
            } else {
              if (value.contains('@')) {
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
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                  borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                      style: BorderStyle.solid)),
              hintText: 'contatorbsoftware@gmail.com',
              labelText: 'Email',
              hintStyle: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic)),
        ),
      ),
          RaisedButton(color: pageColor,
          child: Text('Recuperar Senha',style: TextStyle(color: Colors.white),),
          onPressed: () async {
            _auth.sendPasswordResetEmail(email: controllerEmail.text).then((v){
               scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              'Verifique seu email')));

            });
          },
        ),],)
      ),
    );
  }
}
