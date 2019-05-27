import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
class LoginTelefone extends StatelessWidget {

    final FirebaseAuth _auth = FirebaseAuth.instance;
     String verificationId;
  @override
  Widget build(BuildContext context) {
     var controllerTelefone =
      new MaskedTextController(text: '', mask: '(00) 0 0000-0000');
     final logo = Hero(
        tag: 'hero',
        child: SizedBox(
                width: MediaQuery.of(context).size.width * .3,
                height: MediaQuery.of(context).size.height * .12,
                child: Container(
                  padding: EdgeInsets.all(1),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * .3,
                  height: MediaQuery.of(context).size.height * .12,
                  color: Colors.transparent,
                  child: Image(
                    image: AssetImage('assets/logo_kivaga.png'),
                    width: MediaQuery.of(context).size.width * .7,
                    height: MediaQuery.of(context).size.height * .7,
                  ),
                ),
              ),);

    final email = TextFormField(
      controller: controllerTelefone,
      keyboardType: TextInputType.phone,
      autofocus: false,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Telefone',hintStyle: TextStyle(color: Colors.white),
         suffixIcon: Icon(Icons.phone,color: Colors.white,),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.white)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0),
                          borderSide: BorderSide(color: Colors.white)),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          final PhoneVerificationCompleted verificationCompleted = (FirebaseUser user) {
          print('Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');
    };

    final PhoneVerificationFailed verificationFailed = (AuthException authException) {
        print('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String vid, [int forceResendingToken]) async {
      verificationId = vid;
      print("code sent to " + controllerTelefone.text);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String vid) {
      verificationId = vid;
      print("time out");
    };
    print('Entrou Aqui');

    //'+55'+data.celular.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '')
     return FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+55'+controllerTelefone.text.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', ''),
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout).then((v){
                  Navigator.of(context).pushNamed('/home');
        }).catchError((onError){
      print('Err: ${onError.toString()}');
    });
                
        },
        padding: EdgeInsets.all(12),
        color: Colors.lightBlueAccent,
        child: Text('Entrar', style: TextStyle(color: Colors.white)),
      ),
    );
    final registerLabel = FlatButton(
      child: Text(
        'Cadastre-se',
        style: TextStyle(color: Colors.white),
      ),
      onPressed: () {
        Navigator.of(context).pushNamed('/cadastrotelefone');
      },
    );


    return Scaffold(
  
      body: Stack( children: <Widget>[Image(fit:BoxFit.fill,width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height,image: AssetImage('assets/bg_login.png'),),Center(
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
      ],)
    );
  }
}
