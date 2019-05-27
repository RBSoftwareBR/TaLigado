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
import 'package:shared_preferences/shared_preferences.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EstacionarController implements BlocBase {
    PolylineId selectedPolyline;

  final ruasRef = Firestore.instance.collection('Ruas').reference();
  BehaviorSubject<List<Rua>> ruasController = new BehaviorSubject<List<Rua>>();

  Stream<List<Rua>> get outrua => ruasController.stream;

  Sink<List<Rua>> get inrua => ruasController.sink;

  BehaviorSubject<Map<PolylineId, Polyline>> polysController =new BehaviorSubject<Map<PolylineId, Polyline>>();
  Stream<Map<PolylineId, Polyline>> get outPolys => polysController.stream;

  Sink<Map<PolylineId, Polyline>> get inPolys => polysController.sink;

  EstacionarController() {
    ruasRef
        .where('cidade', isEqualTo: Helper.OuroPreto.id)
        .snapshots()
        .listen((data) {
      List<Rua> ruas = new List<Rua>();
      for (DocumentSnapshot d in data.documents) {
        ruas.add(Rua.fromJson(d.data));
      }
      addPolys(ruas);
      inrua.add(ruas);
    }).onError((err) {
      print('Error: ${err.toString()}');
    });
  }

  @override
  void dispose() {
    ruasController.close();
    polysController.close();
  }

  void addPolys(List<Rua> ruas) {
      Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
    for(Rua r in ruas){
      if (r.points.length > 1) {
        final String polylineIdVal = 'polyline_id_${r.id}';
        final PolylineId polylineId = PolylineId(polylineIdVal);
        final Polyline polyline = Polyline(
          polylineId: polylineId,
          consumeTapEvents: true,
          color: Colors.blue,
          width: 4,
          points: Helper().toLatLng(r.points),
          onTap: () {
            _onPolylineTapped(polylineId);
          },
        );
      
        polylines[polylineId] = polyline;
       
    }
    
  }
  inPolys.add(polylines);
  }
    void _onPolylineTapped(PolylineId polylineId) {
    selectedPolyline = polylineId;
    print(selectedPolyline);
  }
}
