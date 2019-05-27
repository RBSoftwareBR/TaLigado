import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:rxdart/subjects.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CadastroEmailController implements BlocBase {
  BehaviorSubject<User> userController = new BehaviorSubject<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance.collection('Users').reference();

  Stream<User> get outUser => userController.stream;

  Sink<User> get inUser => userController.sink;

  CadastroEmailController() {
    inUser.add(User.Empty());
    /*http
        .get(
           '')
        .then((response) {
      var j = json.decode(response.body);
      for (var v in j) {
      }
    });*/
  }

  @override
  void dispose() {
    userController.close();
  }

  registerUser(User data) {
    return _auth
        .createUserWithEmailAndPassword(
            email: data.email.toLowerCase().replaceAll(' ', ''),
            password: data.senha)
        .then((user) {
      user.sendEmailVerification();
      data.created_at = DateTime.now();
      data.id = user.uid;
      data.foto = user.photoUrl;
      data.updated_at = DateTime.now();
      data.isEmailVerified = user.isEmailVerified;
           data.tipo = 'Email';

      databaseReference
          .document(user.uid)
          .setData({'User': data.toJson()}).catchError((err) {
        print('Erro salvado Usuario: ${err.toString()}');
      });
      return 0;
    }).catchError((err) {
      print('Err: ${err.toString()}');
    });
  }
}
