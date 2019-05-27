import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kivaga/Objetos/Cidade.dart';
import 'package:kivaga/Objetos/Rua.dart';
import 'package:kivaga/Telas/Map/EstacionarController.dart';

class EstacionarPage extends StatefulWidget {
  Cidade cidade;
  EstacionarPage({this.cidade});
  @override
  _EstacionarPageState createState() => _EstacionarPageState();
}

class _EstacionarPageState extends State<EstacionarPage> {
  EstacionarController ec;
  @override
  Widget build(BuildContext context) {
    ec = new EstacionarController();
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .789,
        child: Scaffold(
            body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .75,
                          child: StreamBuilder(
                            stream: ec.outPolys,
                            builder: (context, AsyncSnapshot<Map<PolylineId, Polyline>> snap) {
                              return GoogleMap(
                                onTap: (LatLng pos) {
                                  print(pos);
                                },
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(
                                      widget.cidade.localizacao.latitude,
                                      widget.cidade.localizacao.longitude),
                                  zoom: 17.0,
                                ),
                                polylines: Set<Polyline>.of(snap.data.values),
                                onMapCreated: _onMapCreated,
                              );
                            },
                          )))
                ])));
  }

  GoogleMapController controller;
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }
}
