import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';

var sourceList = [];
final googleSignIn = new GoogleSignIn();
final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();
GoogleSignInAccount user;
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
Future<Null> _ensureLoggedIn() async {
  user = googleSignIn.currentUser;
  if (user == null) {
    user = await googleSignIn.signInSilently();
  }
  if (user == null) {
    user = await googleSignIn.signIn();
    analytics.logLogin();
    userDatabaseReference = databaseReference.child(user.id);
    articleDatabaseReference =
        databaseReference.child(user.id).child('articles');
    articleSourcesDatabaseReference =
        databaseReference.child(user.id).child('sources');
  }
  if (await auth.currentUser() == null) {
    _googleSignIn.signIn().then((googleUser) async {
      print(googleUser.toString());
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await auth.signInWithCredential(credential);
    });
    print('USER AQUI');
  } else {
    userDatabaseReference = databaseReference.child(user.id);
    articleDatabaseReference =
        databaseReference.child(user.id).child('articles');
    articleSourcesDatabaseReference =
        databaseReference.child(user.id).child('sources');
  }
}

var logIn = _ensureLoggedIn();
