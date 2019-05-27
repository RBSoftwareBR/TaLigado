import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:kivaga/Helpers/Helper.dart';
import 'package:kivaga/Helpers/Instagram.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:rxdart/subjects.dart';

class LoginController implements BlocBase {
  BehaviorSubject<User> _UserController = new BehaviorSubject<User>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  final databaseReference = Firestore.instance.collection('Users').reference();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  Stream<User> get outUser => _UserController.stream;

  Sink<User> get inUser => _UserController.sink;

  LoginController() {
    /* http.get('').then((response) {
      var j = json.decode(response.body);
      for (var v in j) {}
    });*/
  }

  onError(err) {
    print('Error: ${err.toString()}');
  }

  Future LoginGoogle() async {
    return _googleSignIn.signIn().then((googleUser) async {
      print(googleUser.toString());
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final FirebaseUser user = await _auth.signInWithCredential(credential);
      assert(user.email != null);
      assert(user.displayName != null);
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final FirebaseUser currentUser = await _auth.currentUser();
      print('AQUI USUARIO ${user.toString()}');
      assert(user.uid == currentUser.uid);
      User data = new User.Empty();
      data.created_at = DateTime.now();
      data.nome = user.displayName;
      data.email = user.email;
      data.foto = user.photoUrl;
      data.data_nascimento = null;
      data.id = user.uid;
      data.updated_at = DateTime.now();
      data.isEmailVerified = user.isEmailVerified;
      data.tipo = 'Google';

      databaseReference
          .document(user.uid)
          .setData({'User': data.toJson()}).catchError((err) {
        print('Erro salvado Usuario: ${err.toString()}');
      });
      Helper().setUserType('Google');
      return 0;
    }).catchError((err) {
      print('Erro no Login com Google ${err.toString()}');
    });
  }

  Future LoginInstagram() async {
    Token t = await getToken();
    Helper().setUserType('Instagram');
    return _auth
        .signInWithEmailAndPassword(
            email: t.id + '@instagram.com', password: '123456')
        .then((user) async {
      if (user != null) {
        print('Logou');
        return 0;
      } else {
        final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
            email: t.id + '@instagram.com', password: '123456');
            UserUpdateInfo upi = new UserUpdateInfo();
            upi.photoUrl = t.profile_picture;
            upi.displayName = t.username;
            user.updateProfile(upi);
        User data = new User.Empty();
        data.created_at = DateTime.now();
        data.nome = user.displayName;
        data.email = t.id + '@instagram.com';
        data.foto = user.photoUrl;
        data.data_nascimento = null;
        data.id = user.uid;
        data.updated_at = DateTime.now();
        data.isEmailVerified = user.isEmailVerified;
        data.tipo = 'Instagram';

        databaseReference
            .document(user.uid)
            .setData({'User': data.toJson()}).catchError((err) {
          print('Erro salvado Usuario: ${err.toString()}');
        });
        return 0;

        print('AQUI USUARIO ${user.toString()}');
      }
    }).catchError(onError);
  }

  getUserfacebookProfile(result) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    print(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final user = json.decode(graphResponse.body);
    print(user);

    User data = new User.Empty();
    data.created_at = DateTime.now();
    data.nome = user['name'];
    data.email = user['email'];
    data.foto =
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}';
    data.data_nascimento = null;
    data.id = user['id'];
    data.updated_at = DateTime.now();
    data.isEmailVerified = true;
    data.tipo = 'Facebook';

    databaseReference
        .document(user['id'])
        .setData({'User': data.toJson()}).catchError((err) {
      print('Erro salvado Usuario: ${err.toString()}');
    });
    print('AQUI PROFILE ${user.toString()}');
        return 0;
  }

  Future LoginTwitter() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: 'PFaXsKzjtBFewWjbFvPlUmW6R   ',
      consumerSecret: 'Vsgqiautu8KWjApPrpkOMtZDcF6mhr9JCg8cyPAw6SOVgnrRII ',
    );

    final TwitterLoginResult result = await twitterLogin.authorize();

    switch (result.status) {
      case TwitterLoginStatus.loggedIn:
        //return'Logged in! username: ${result.session.username}';
        final AuthCredential credential = TwitterAuthProvider.getCredential(
            authToken: result.session.token,
            authTokenSecret: result.session.secret);
        final FirebaseUser user = await _auth.signInWithCredential(credential);

        print('AQUI USUARIO ${user.toString()}');
        final FirebaseUser currentUser = await _auth.currentUser();
        Helper().setUserType('Twitter');
        if (user != null) {
          User data = new User.Empty();
          data.created_at = DateTime.now();
          data.nome = user.displayName;
          data.email = user.email;
          data.foto = user.photoUrl;
          data.data_nascimento = null;
          data.id = user.uid;
          data.updated_at = DateTime.now();
          data.isEmailVerified = user.isEmailVerified;
          data.tipo = 'Twitter';

          databaseReference
              .document(user.uid)
              .setData({'User': data.toJson()}).catchError((err) {
            print('Erro salvado Usuario: ${err.toString()}');
          });
              return 0;
        } else {
          return 'Failed to sign in with Twitter. ';
        }
        break;
      case TwitterLoginStatus.cancelledByUser:
        return 'Login cancelled by user.';
        break;
      case TwitterLoginStatus.error:
        return 'Login error: ${result.errorMessage}';
        break;
    }
  }

  Future LoginFacebook() async {
    final FacebookLoginResult result =
        await facebookSignIn.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        getUserfacebookProfile(result);

        final AuthCredential credential = FacebookAuthProvider.getCredential(
          accessToken: accessToken.token,
        );
        final FirebaseUser user = await _auth.signInWithCredential(credential);
        print('AQUI USUARIO ${user.toString()}');
        Helper().setUserType('Facebook');
            return 0;
        break;
      case FacebookLoginStatus.cancelledByUser:
        return 'Login cancelled by the user.';
        break;
      case FacebookLoginStatus.error:
        return 'Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}';
        break;
    }
  }

  @override
  void dispose() {
    _UserController.close();
  }
}
