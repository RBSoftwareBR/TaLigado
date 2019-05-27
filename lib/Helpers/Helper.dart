import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as maps;
import 'package:kivaga/Objetos/Cidade.dart';
import 'package:kivaga/Objetos/User.dart';
import 'package:latlong/latlong.dart';
import 'package:latlong/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Helper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseUser user;
  static Color blue_default = Colors.blue;
  static User localUser;
  static FirebaseMessaging fbmsg;
  static String UserType;
  static String INSTAGRAM_APP_ID = "237a05e3e39541788fd96532e02f5459";
  static String INSTAGRAM_APP_SECRET = "e6bc2c55e3354f92ae4fdcce36107f1a";
  static Cidade Castro = Cidade(
      id: '-Lf_sLW6pg2DW90t7wrc',
      created_at: DateTime.now(),
      deleted_at: null,
      estado: 'PR',
      localizacao: LatLng(-24.794201, -49.9958861),
      nome: 'Castro',
      updated_at: DateTime.now());

  static Cidade OuroPreto = Cidade(
      id: '-Lf_sLWEsBRWsRJfX2LT',
      created_at: DateTime.now(),
      deleted_at: null,
      estado: 'MG',
      localizacao: LatLng(-20.3860263, -43.5039788),
      nome: 'Ouro Preto',
      updated_at: DateTime.now());
  static Cidade Mariana = Cidade(
      id: '-Lf_sLWKAWyIC1bWFRbs',
      created_at: DateTime.now(),
      deleted_at: null,
      estado: 'MG',
      localizacao: LatLng(-20.3658, -43.4181027),
      nome: 'Mariana',
      updated_at: DateTime.now());
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

  toLatLng(List<LatLng> points) {
    List<maps.LatLng> lpoints = new List<maps.LatLng>();
    for (LatLng p in points) {
      lpoints.add(maps.LatLng(p.latitude, p.longitude));
    }
    return lpoints;
  }

  toPoints(List<maps.LatLng> points) {
    List<LatLng> lpoints = new List<LatLng>();
    for (maps.LatLng p in points) {
      lpoints.add(LatLng(p.latitude, p.longitude));
    }
    return lpoints;
  }
}
