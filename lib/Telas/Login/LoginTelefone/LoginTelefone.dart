import 'package:flutter/material.dart';

class LoginTelefone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     final logo = Hero(
        tag: 'hero',
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .3,
          height: MediaQuery.of(context).size.height * .3,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            child: Image(
              image: AssetImage('assets/logorb.png'),
              width: MediaQuery.of(context).size.width * .45,
              height: MediaQuery.of(context).size.height * .45,
            ),
          ),
        ));

    final email = TextFormField(
      keyboardType: TextInputType.phone,
      autofocus: false,
      initialValue: '',
      decoration: InputDecoration(
        hintText: 'Telefone',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.of(context).pushNamed('/home');
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Entrar', style: TextStyle(color: Colors.white)),
      ),
    );
    final registerLabel = FlatButton(
      child: Text(
        'Cadastre-se?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/cadastrotelefone');
      },
    );


    return Scaffold(
      appBar: AppBar(
        title: Text('LoginTelefone'),
      ),
      body: Center(
        child: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            logo,
            SizedBox(height: 48.0),
            email,
            SizedBox(height: 24.0),
            loginButton,
            registerLabel,
          ],
        ),
      ),
      ),
    );
  }
}
