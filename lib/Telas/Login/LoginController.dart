import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:imoveis/Helpers/Helper.dart';
import 'package:imoveis/Helpers/Instagram.dart';
import 'package:imoveis/Helpers/data/model/User.dart';
import 'package:rxdart/subjects.dart';

class LoginController implements BlocBase {
  BehaviorSubject<User> _UserController = new BehaviorSubject<User>();
  static final FacebookLogin facebookSignIn = new FacebookLogin();
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

  Future LoginGoogle() async {
    _googleSignIn.signIn().then((googleUser) async {
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
      Helper().setUserType('Google');
    }).catchError((err) {
      print('Erro no Login com Google ${err.toString()}');
    });
  }

  Future LoginInstagram() async {
    Token t = await getToken();
    Helper().setUserType('Instagram');
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: t.id + '@instagram.com', password: '123456');
    print('AQUI USUARIO ${user.toString()}');
  }

  getUserfacebookProfile(result) async {
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    print(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    print('AQUI PROFILE ${profile.toString()}');
  }

  Future LoginTwitter() async {
    var twitterLogin = new TwitterLogin(
      consumerKey: 'WpV2exYj194Dbssg9e9l8mgx0 ',
      consumerSecret: 'fxV0JbuDzA3L6gCrtweOEv27O4bxMzGNIurYnNYK87y0JlzRnz ',
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
        assert(user.uid == currentUser.uid);
        Helper().setUserType('Twitter');
        if (user != null) {
          return 'Successfully signed in with Twitter. ' + user.uid;
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
        return 'Logged in! Token: ${accessToken.token} User id: ${accessToken.userId} Expires: ${accessToken.expires} Permissions: ${accessToken.permissions} Declined permissions: ${accessToken.declinedPermissions}';
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
