import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:rxdart/subjects.dart';

class CadastroTelefoneController implements BlocBase {
  BehaviorSubject<User> userController = new BehaviorSubject<User>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String verificationId;
  final databaseReference = Firestore.instance.collection('Users').reference();

  Stream<User> get outUser => userController.stream;

  Sink<User> get inUser => userController.sink;

  CadastroTelefoneController() {
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
    final PhoneVerificationCompleted verificationCompleted =
        (FirebaseUser user) {
      print(
          'Inside _sendCodeToPhoneNumber: signInWithPhoneNumber auto succeeded: $user');

      data.created_at = DateTime.now();
      data.updated_at = DateTime.now();
      data.isEmailVerified = user.isEmailVerified;
      data.id = user.uid;
       data.foto = user.photoUrl;
      data.tipo = 'Telefone';
      

      databaseReference
          .document(user.uid)
          .setData({'User': data.toJson()}).catchError((err) {
        print('Erro salvado Usuario: ${err.toString()}');
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      print(
          'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    };

    final PhoneCodeSent codeSent =
        (String vid, [int forceResendingToken]) async {
      verificationId = vid;
      print("code sent to " + data.celular);
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String vid) {
      verificationId = vid;
      print("time out");
    };
    print('Entrou Aqui');

    //'+55'+data.celular.replaceAll('(', '').replaceAll(')', '').replaceAll('-', '').replaceAll(' ', '')
    return FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: '+55' +
                data.celular
                    .replaceAll('(', '')
                    .replaceAll(')', '')
                    .replaceAll('-', '')
                    .replaceAll(' ', ''),
            timeout: const Duration(seconds: 5),
            verificationCompleted: verificationCompleted,
            verificationFailed: verificationFailed,
            codeSent: codeSent,
            codeAutoRetrievalTimeout: codeAutoRetrievalTimeout)
        .then((v) async {
   
      return 0;
    }).catchError((onError) {
      print('Err: ${onError.toString()}');
    });
  }
}
