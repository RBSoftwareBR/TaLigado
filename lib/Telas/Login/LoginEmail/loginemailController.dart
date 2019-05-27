import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:kivaga/Helpers/data/model/User.dart';
import 'package:rxdart/subjects.dart';

class LoginEmailController implements BlocBase {
  BehaviorSubject<User> userController = new BehaviorSubject<User>();

  Stream<User> get outuser => userController.stream;

  Sink<User> get inuser => userController.sink;

  LoginEmailController() {}

  @override
  void dispose() {
    userController.close();
  }
}
