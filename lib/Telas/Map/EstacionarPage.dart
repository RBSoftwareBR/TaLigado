import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kivaga/Objetos/Cidade.dart';
import 'package:kivaga/Objetos/Rua.dart';
import 'package:kivaga/Telas/Map/EstacionarController.dart';
import 'package:kivaga/Telas/Payment/PagamentoController.dart';

class EstacionarPage extends StatefulWidget {
  Cidade cidade;
  PagamentoController pc;
  EstacionarPage({this.cidade, this.pc});
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
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .04,
                child: StreamBuilder(
                  stream: widget.pc.outSaldo,
                  initialData: 'R\$ 0,00',
                  builder: (context, transacoes) {
                    return Text(
                      'Saldo Atual: R\$ ${transacoes.data}',
                      style: TextStyle(
                          color: Colors.orangeAccent,
                          fontStyle: FontStyle.italic,
                          fontSize: 26),
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width - 15,
                  height: 1,
                  color: Colors.blue,
                ),
              ),
              Center(
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * .72,
                      child: StreamBuilder(
                        stream: ec.outPolys,
                        builder: (context,
                            AsyncSnapshot<Map<PolylineId, Polyline>> snap) {
                          return StreamBuilder(
                            stream: ec.outrua,
                            builder: (context, ruas) {
                              return ruas.hasData
                                  ? FutureBuilder(
                                      future: getMarkers(ruas.data),
                                      builder: (context, markers) {
                                        return GoogleMap(
                                          onTap: (LatLng pos) {
                                            print(pos);
                                          },
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                widget.cidade.localizacao
                                                    .latitude,
                                                widget.cidade.localizacao
                                                    .longitude),
                                            zoom: 17.0,
                                          ),
                                          markers: ruas.hasData
                                              ? markers.data
                                              : Set<Marker>(),
                                          polylines: snap.hasData
                                              ? Set<Polyline>.of(
                                                  snap.data.values)
                                              : Set<Polyline>(),
                                          onMapCreated: _onMapCreated,
                                        );
                                      })
                                  : GoogleMap(
                                      onTap: (LatLng pos) {
                                        print(pos);
                                      },
                                      initialCameraPosition: CameraPosition(
                                        target: LatLng(
                                            widget.cidade.localizacao.latitude,
                                            widget
                                                .cidade.localizacao.longitude),
                                        zoom: 17.0,
                                      ),
                                      markers: Set<Marker>(),
                                      polylines: snap.hasData
                                          ? Set<Polyline>.of(snap.data.values)
                                          : Set<Polyline>(),
                                      onMapCreated: _onMapCreated,
                                    );
                              ;
                            },
                          );
                        },
                      )))
            ])));
  }

  GoogleMapController controller;
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  Future<Set<Marker>> getMarkers(List<Rua> ruas) async {
    List<Marker> markers = new List<Marker>();
    for (Rua r in ruas) {
      Random random = new Random();
      int vagas = random.nextInt(12);
      ui.PictureRecorder pr = ui.PictureRecorder();
      print('Chegou AQUI DEMO' + pr.isRecording.toString());

      Canvas c = new Canvas(pr);
      c.save();
      Paint p = new Paint();
      p.color = vagas == 0 ? Colors.red : Colors.green;
      c.drawCircle(Offset(45, 45), 45, p);
      TextPainter tp = new TextPainter(
        textDirection: TextDirection.ltr,
        text: TextSpan(
            text: vagas.toString(),
            style: TextStyle(color: Colors.white, fontSize: 43)),
      );

      tp.layout(maxWidth: 90, minWidth: 60);
      tp.paint(
          c, vagas.toString().length == 1 ? Offset(33, 20) : Offset(20, 19));

      ui.Image img = await pr.endRecording().toImage(90, 90);
      ByteData bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      print('Chegou AQUI DEMO ${bytes.buffer.asUint8List()}');
      BitmapDescriptor b =
          BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());

      print('Chegou AQUI DEMO' + LatLng(r.lat, r.lng).toString());
      Marker m = new Marker(
          markerId: MarkerId(r.id),
          consumeTapEvents: true,
          anchor: Offset(0, 1.1),
          icon: b,
          onTap: () {},
          position: LatLng(r.lat, r.lng),
          draggable: false,
          visible: true);
      markers.add(m);
    }
    return markers.toSet();
  }
}
