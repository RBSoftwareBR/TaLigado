import 'dart:convert';

import 'package:latlong/latlong.dart';

class Rua {
  String id;
  String rua;
  List<LatLng> points;
  int vagas_total;
  int vagas_disponiveis;
  String cidade;
  double lat;
  double lng;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;

  Rua(
      {this.id,
      this.rua,
      this.points,
      this.vagas_total,
      this.vagas_disponiveis,
      this.cidade,
      this.lat,
      this.lng,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Rua.Empty();

  Rua.fromJson(Map<String, dynamic> json) {
    this.id = json["id"];
    this.rua = json["rua"];
    this.points = _getPoints(json['points']);
    this.vagas_total = int.parse(json["vagas_total"].toString());
    this.vagas_disponiveis = int.parse(json["vagas_disponiveis"].toString());
    this.cidade = json["cidade"];
    this.lat = double.parse(json["lat"].toString());
    this.lng = double.parse(json["lng"].toString());
    this.created_at = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json["created_at"]);
    this.updated_at = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]);
    this.deleted_at = json['deleted_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "rua": this.rua,
      "points": _generatePoints(this.points),
      "vagas_total": this.vagas_total,
      "vagas_disponiveis": this.vagas_disponiveis,
      "cidade": this.cidade,
      "lat": this.lat,
      "lng": this.lng,
      "created_at": this.created_at!= null? this.created_at.millisecondsSinceEpoch:null,
      "updated_at": this.updated_at!= null? this.updated_at.millisecondsSinceEpoch:null,
      "deleted_at": this.deleted_at!= null? this.deleted_at.millisecondsSinceEpoch:null,
    };
  }

  List<LatLng> _getPoints(j) {
    print('AQUI JSON ${json}');
    List<LatLng> points = new List<LatLng>();
    for(var i in json.decode(j)){
      points.add(LatLng(i['lat'], i['lng']));
    };
    return points;
  }

  _generatePoints(List<LatLng> points) {
    List<dynamic> l = new List();
    for (var p in points) {
      l.add({'lat': p.latitude, 'lng': p.longitude});
    }
    return json.encode(l);
  }

  @override
  String toString() {
    return 'Rua{id: $id, rua: $rua, points: $points, vagas_total: $vagas_total, vagas_disponiveis: $vagas_disponiveis, cidade: $cidade, lat: $lat, lng: $lng, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  
}
