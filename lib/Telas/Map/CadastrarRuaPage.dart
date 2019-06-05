import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kivaga/Objetos/Cidade.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kivaga/Telas/Map/CadastrarRuaController.dart';

class CadastrarRuaPage extends StatefulWidget {
  Cidade cidade;
  CadastrarRuaPage({this.cidade});
  @override
  _CadastrarRuaPageState createState() => _CadastrarRuaPageState();
}

class _CadastrarRuaPageState extends State<CadastrarRuaPage> {
  CadastrarRuaController mc = new CadastrarRuaController();
  @override
  Widget build(BuildContext context) {
    final bool iOSorNotSelected = Platform.isIOS || (selectedPolyline == null);
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .789,
        child: Scaffold(floatingActionButton: FloatingActionButton(onPressed: (){
          mc.SalvarRua();
        },child:Icon(Icons.save,color:Colors.white),backgroundColor: Colors.blue,),
            body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .75,
                child:StreamBuilder(stream:mc.outPolys ,builder: (context,AsyncSnapshot<Map<PolylineId, Polyline>> snap){
                  return GoogleMap(onTap: (LatLng pos){
                  print(pos);
                  mc.addPoly(pos);
                },
                  initialCameraPosition: CameraPosition(
                    target: LatLng(widget.cidade.localizacao.latitude,
                        widget.cidade.localizacao.longitude),
                    zoom: 17.0,
                  ),
                  polylines: snap.hasData
                      ? Set<Polyline>.of(snap.data.values)
                      : Set<Polyline>(),
                  onMapCreated: _onMapCreated,
                );
                },) 
              ),
            ),
           /* Expanded(
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('add'),
                              onPressed: _add,
                            ),
                            FlatButton(
                              child: const Text('remove'),
                              onPressed:
                                  (selectedPolyline == null) ? null : _remove,
                            ),
                            FlatButton(
                              child: const Text('toggle visible'),
                              onPressed: (selectedPolyline == null)
                                  ? null
                                  : _toggleVisible,
                            ),
                            FlatButton(
                              child: const Text('toggle geodesic'),
                              onPressed: (selectedPolyline == null)
                                  ? null
                                  : _toggleGeodesic,
                            ),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FlatButton(
                              child: const Text('change width'),
                              onPressed: (selectedPolyline == null)
                                  ? null
                                  : _changeWidth,
                            ),
                            FlatButton(
                              child: const Text('change color'),
                              onPressed: (selectedPolyline == null)
                                  ? null
                                  : _changeColor,
                            ),
                            FlatButton(
                              child:
                                  const Text('change start cap [Android only]'),
                              onPressed:
                                  iOSorNotSelected ? null : _changeStartCap,
                            ),
                            FlatButton(
                              child:
                                  const Text('change end cap [Android only]'),
                              onPressed:
                                  iOSorNotSelected ? null : _changeEndCap,
                            ),
                            FlatButton(
                              child: const Text(
                                  'change joint type [Android only]'),
                              onPressed:
                                  iOSorNotSelected ? null : _changeJointType,
                            ),
                            FlatButton(
                              child:
                                  const Text('change pattern [Android only]'),
                              onPressed:
                                  iOSorNotSelected ? null : _changePattern,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),*/
          ],
        )));
  }

  GoogleMapController controller;
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{};
  int _polylineIdCounter = 1;
  PolylineId selectedPolyline;

  // Values when toggling polyline color
  int colorsIndex = 0;
  List<Color> colors = <Color>[
    Colors.purple,
    Colors.red,
    Colors.green,
    Colors.pink,
  ];

  // Values when toggling polyline width
  int widthsIndex = 0;
  List<int> widths = <int>[10, 20, 5];

  int jointTypesIndex = 0;
  List<JointType> jointTypes = <JointType>[
    JointType.mitered,
    JointType.bevel,
    JointType.round
  ];

  // Values when toggling polyline end cap type
  int endCapsIndex = 0;
  List<Cap> endCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline start cap type
  int startCapsIndex = 0;
  List<Cap> startCaps = <Cap>[Cap.buttCap, Cap.squareCap, Cap.roundCap];

  // Values when toggling polyline pattern
  int patternsIndex = 0;
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[],
    <PatternItem>[
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)],
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)],
  ];

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onPolylineTapped(PolylineId polylineId) {
    setState(() {
      selectedPolyline = polylineId;
    });
  }

  void _remove() {
    setState(() {
      if (polylines.containsKey(selectedPolyline)) {
        polylines.remove(selectedPolyline);
      }
      selectedPolyline = null;
    });
  }

  void _add() {
    print('ADD');
    final int polylineCount = polylines.length;
    final String polylineIdVal = 'polyline_id_$_polylineIdCounter';
    _polylineIdCounter++;
    final PolylineId polylineId = PolylineId(polylineIdVal);

    final Polyline polyline = Polyline(
      polylineId: polylineId,
      consumeTapEvents: true,
      color: Colors.orange,
      width: 5,
      points: _createPoints(),
      onTap: () {
        _onPolylineTapped(polylineId);
      },
    );

    setState(() {
      polylines[polylineId] = polyline;
    });
  }

  void _toggleGeodesic() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        geodesicParam: !polyline.geodesic,
      );
    });
  }

  void _toggleVisible() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        visibleParam: !polyline.visible,
      );
    });
  }

  void _changeColor() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        colorParam: colors[++colorsIndex % colors.length],
      );
    });
  }

  void _changeWidth() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        widthParam: widths[++widthsIndex % widths.length],
      );
    });
  }

  void _changeJointType() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        jointTypeParam: jointTypes[++jointTypesIndex % jointTypes.length],
      );
    });
  }

  void _changeEndCap() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        endCapParam: endCaps[++endCapsIndex % endCaps.length],
      );
    });
  }

  void _changeStartCap() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        startCapParam: startCaps[++startCapsIndex % startCaps.length],
      );
    });
  }

  void _changePattern() {
    final Polyline polyline = polylines[selectedPolyline];
    setState(() {
      polylines[selectedPolyline] = polyline.copyWith(
        patternsParam: patterns[++patternsIndex % patterns.length],
      );
    });
  }
                        
  List<LatLng> _createPoints() {
    final List<LatLng> points = <LatLng>[];
    final double offset = _polylineIdCounter.ceilToDouble();
    points.add(_createLatLng(widget.cidade.localizacao.latitude + offset, widget.cidade.localizacao.longitude));
    points.add(_createLatLng(widget.cidade.localizacao.latitude + offset, widget.cidade.localizacao.longitude));
    points.add(_createLatLng(widget.cidade.localizacao.latitude + offset, widget.cidade.localizacao.longitude));
    points.add(_createLatLng(widget.cidade.localizacao.latitude + offset, widget.cidade.localizacao.longitude));
    return points;
  }

  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }
}
