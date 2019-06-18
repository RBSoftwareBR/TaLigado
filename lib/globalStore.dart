import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rxdart/subjects.dart';

var sourceList = [];
final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
FirebaseUser user;
final databaseReference = FirebaseDatabase.instance.reference();
var userDatabaseReference;
var articleSourcesDatabaseReference;
final GoogleSignIn _googleSignIn = GoogleSignIn(
  signInOption: SignInOption.standard,
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);
var articleDatabaseReference;
Future<Null> ensureLoggedIn() async {
  if (user != null) {
    analytics.logLogin();
    userDatabaseReference = databaseReference.child(user.uid);
    articleDatabaseReference =
        databaseReference.child(user.uid).child('articles');
    articleSourcesDatabaseReference =
        databaseReference.child(user.uid).child('sources');
  } else {
    user = await auth.currentUser();
  }
}

class LoginController implements BlocBase {
  BehaviorSubject<FirebaseUser> _UserController =
      new BehaviorSubject<FirebaseUser>();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<FirebaseUser> get outUser => _UserController.stream;

  Sink<FirebaseUser> get inUser => _UserController.sink;

  BehaviorSubject<File> imageController = new BehaviorSubject<File>();
  Stream<File> get outImage => imageController.stream;

  Sink<File> get inImage => imageController.sink;
  LoginController() {
    isLogedIn();
  }
  @override
  void dispose() {
    _UserController.close();
    imageController.close();
    // TODO: implement dispose
  }

  Future<bool> isLogedIn() async {
    FirebaseUser u = await _auth.currentUser();
    inUser.add(u);
    user = u;
    print(" AQUI USUARIO" + u.toString());
    ensureLoggedIn();
    return u != null;
  }

  void createUser(String nome, foto) {
    Random r = new Random();

    _auth
        .createUserWithEmailAndPassword(
            email: nome.trim() + r.nextInt(999).toString() + '@hotmail.com',
            password: '123456')
        .then((fbuser) async {
      UserUpdateInfo upi = new UserUpdateInfo();
      if (foto != null) {
        var pic = await _uploadFile(fbuser.uid, foto);

        upi.photoUrl = pic;
      }

      upi.displayName = nome;
      fbuser.updateProfile(upi).then((t) {
        print('UPDATE USUARIO DEMONIO');
        isLogedIn();
      }).catchError((err) {
        print('ERRO AQUI FDP ${err.toString()}');
      });
    });
  }

  Future _uploadFile(uid, File file) async {
    print("AQUI FILE" + file.path);
    final StorageReference ref =
        new FirebaseStorage().ref().child('profiles').child(uid + '.png');
    return ref
        .putFile(
          file,
          StorageMetadata(
            customMetadata: <String, String>{'activity': 'test'},
          ),
        )
        .onComplete
        .then((complete) async {
      return await complete.ref.getDownloadURL();
    });
  }

  void logOf() {
    _auth.signOut().then((v) {
      user = null;
      inUser.add(null);
    });
  }
}
