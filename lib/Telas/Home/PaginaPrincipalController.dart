import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:rxdart/rxdart.dart';

class PagesController implements BlocBase {
  BehaviorSubject<int> _controllerPage = new BehaviorSubject<int>();

  Stream<int> get outPageController => _controllerPage.stream;

  Sink<int> get inPageController => _controllerPage.sink;
  BehaviorSubject<double> controllerScreenSize = new BehaviorSubject<double>();
  Stream<double> get outScreenSize => controllerScreenSize.stream;
  Sink<double> get inScreenSize => controllerScreenSize.sink;

  @override
  void dispose() {
    controllerScreenSize.close();
    _controllerPage.close();
  }

  PagesController(int page, context) {
    inPageController.add(page);

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        print(visible);
        if (visible) {
          inScreenSize.add((MediaQuery.of(context).size.height * .789) / 3);
          print('Reduzido');
        } else {
          print('Normal');
          inScreenSize.add(
            MediaQuery.of(context).size.height * .789,
          );
        }
      },
    );
  }
}
