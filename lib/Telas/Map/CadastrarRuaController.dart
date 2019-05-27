import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:kivaga/Helpers/Helper.dart';
import 'package:kivaga/Objetos/Rua.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CadastrarRuaController implements BlocBase {
  final databaseReference = Firestore.instance.collection('Ruas').reference();
  final cidadesRef = Firestore.instance.collection('Cidades').reference();
  BehaviorSubject<Rua> ruaController = new BehaviorSubject<Rua>();

  Stream<Rua> get outrua => ruaController.stream;
  PolylineId selectedPolyline;

  Sink<Rua> get inrua => ruaController.sink;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};

  BehaviorSubject<Map<PolylineId, Polyline>> polysController =
      new BehaviorSubject<Map<PolylineId, Polyline>>();
  Stream<Map<PolylineId, Polyline>> get outPolys => polysController.stream;

  Sink<Map<PolylineId, Polyline>> get inPolys => polysController.sink;
  List<LatLng> points = new List<LatLng>();
  BehaviorSubject<List<LatLng>> pointsController =
      new BehaviorSubject<List<LatLng>>();

  Stream<List<LatLng>> get outPoints => pointsController.stream;

  Sink<List<LatLng>> get inPoints => pointsController.sink;
  CadastrarRuaController() {
    /*cidadesRef.add(Helper.Castro.toJson());
    cidadesRef.add(Helper.OuroPreto.toJson());
    cidadesRef.add(Helper.Mariana.toJson());*/
    inPolys.add(polylines);
    inPoints.add(points);
  }

  Future<List<LatLng>> snapToRoads(List<LatLng> points) {
    //pathExample
    //?path=-35.27801,149.12958|-35.28032,149.12907|-35.28099,149.12929|-35.28144,149.12984|-35.28194,149.13003|-35.28282,149.12956|-35.28302,149.12881|-35.28473,149.12836
    String path = '';
    for (int i = 0; i < points.length; i++) {
      path = path + '${points[i].latitude},${points[i].longitude}';
      if (i != points.length - 1) {
        path = path + '|';
      }
    }

    String url =
        'https://roads.googleapis.com/v1/snapToRoads?interpolate=true&key=AIzaSyCbXnPT3n-bTsDmTYPfNAk4zWCn88SlnF4&path=${path}';
    print(url);
    return http.get(url).then((data) {
      print(data.body);
      List<LatLng> newPoints = new List<LatLng>();
      for (var j in json.decode(data.body)['snappedPoints']) {
        print(j);
        newPoints.add(
            new LatLng(j['location']['latitude'], j['location']['longitude']));
      }
      return newPoints;
    });
  }

  SalvarRua() {
    Rua r = new Rua(
        cidade: Helper.OuroPreto.id,
        created_at: DateTime.now(),
        deleted_at: null,
        updated_at: DateTime.now(),
        lat: points[(points.length / 2).floor()].latitude,
        lng: points[(points.length / 2).floor()].longitude,
        points: Helper().toPoints(points),
        rua: 'Rua Teste',
        vagas_disponiveis: 10,
        vagas_total: 10);
    databaseReference.reference().add(r.toJson()).then((dr){
      r = new Rua(
        id: dr.documentID,
        cidade: Helper.OuroPreto.id,
        created_at: DateTime.now(),
        deleted_at: null,
        updated_at: DateTime.now(),
        lat: points[(points.length / 2).floor()].latitude,
        lng: points[(points.length / 2).floor()].longitude,
        points: Helper().toPoints(points),
        rua: 'Rua Teste',
        vagas_disponiveis: 10,
        vagas_total: 10);
      databaseReference.document(dr.documentID).updateData(r.toJson());
    });
  }

  addPoly(LatLng point) {
    points.add(point);
    snapToRoads(points).then((p) {
      points = p;
      inPoints.add(points);

      if (points.length > 1) {
        final String polylineIdVal = 'polyline_id_$points.length';
        final PolylineId polylineId = PolylineId(polylineIdVal);
        final Polyline polyline = Polyline(
          polylineId: polylineId,
          consumeTapEvents: true,
          color: Colors.blue,
          width: 4,
          points: points,
          onTap: () {
            _onPolylineTapped(polylineId);
          },
        );
        Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
        polylines[polylineId] = polyline;
        inPolys.add(polylines);
      }
    });
  }

  void _onPolylineTapped(PolylineId polylineId) {
    selectedPolyline = polylineId;
    print(selectedPolyline);
  }

  @override
  void dispose() {
    ruaController.close();
    polysController.close();
    pointsController.close();
  }
}
