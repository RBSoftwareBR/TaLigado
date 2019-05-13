import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser user;
  static String UserType;
  static String INSTAGRAM_APP_ID = "d080d68f7d824504a3b6aee8bcecd15f";
  static String INSTAGRAM_APP_SECRET = "2b1fae4d943b486dbb589523a765fd7a";
  setUserType(String type) {
    UserType = type;
    SharedPreferences.getInstance().then((sp) {
      sp.setString('UserType', type);
    }).catchError((err) {
      print('Erro ao gravar UserType: ${err.toString()}');
    });
  }

  Helpers() {
    if (user == null) {
      getUser();
    }
  }

  getUser() async {
    user = await _auth.currentUser();
  }
}
