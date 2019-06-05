import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:kivaga/Telas/Home/Home.dart';
import 'package:kivaga/Telas/Login/Login.dart';
import 'package:kivaga/Telas/Login/LoginEmail/CadastroEmail/cadastroemail.dart';
import 'package:kivaga/Telas/Login/LoginEmail/EsqueceuSenha/EsqueceuSenha.dart';
import 'package:kivaga/Telas/Login/LoginEmail/LoginEmail.dart';
import 'package:kivaga/Telas/Login/LoginTelefone/CadastroTelefone/CadastroTelefone.dart';
import 'package:kivaga/Telas/Login/LoginTelefone/LoginTelefone.dart';
import 'package:kivaga/Telas/Payment/PagamentoPage.dart';

import 'Helpers/Helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  final userRef = Firestore.instance.collection('Users').reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.blue));

    return MaterialApp(
        title: 'kivaga',
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/loginemail': (BuildContext context) => LoginEmail(),
          '/logintelefone': (BuildContext context) => LoginTelefone(),
          '/home': (BuildContext context) => HomePage(),
          '/login': (BuildContext context) => Login(),
          '/cadastroemail': (BuildContext context) => CadastroEmail(),
          '/cadastrotelefone': (BuildContext context) => CadastroTelefone(),
          '/esqueceusenha': (BuildContext context) => EsqueceuSenha(),
          '/pagamento': (BuildContext context) => PagamentoPage(),
        },
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],
        home: FutureBuilder(
          future: _auth.currentUser(),
          builder: (context, AsyncSnapshot<FirebaseUser> future) {
            print('AQUI FUTURE ${future.data}');
            if (future.hasData) {
              return FutureBuilder(
                  future: userRef.document(future.data.uid).get(),
                  builder: (context, v) {
                    if(v.hasData) {
                      print('LALALALALA');
                      print('DATA' + v.data['User'].toString());
                      Helper.localUser = User.fromJson(v.data['User']);
                      print('Return Home');
                      return HomePage();
                    }else{
                      return Login();
                    }
                  });
            } else {
              print('Return Login');
              return Login();
            }
          },
        ));
  }
}
