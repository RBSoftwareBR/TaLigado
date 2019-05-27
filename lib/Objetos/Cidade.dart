import 'package:latlong/latlong.dart';

class Cidade {
  String id;
  String nome;
  LatLng localizacao;
  String estado;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  Cidade(
      {this.id,
      this.nome,
      this.localizacao,
      this.estado,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Cidade.Empty();

  factory Cidade.fromJson(Map<String, dynamic> json) {
    return Cidade(
      id: json["id"],
      nome: json["nome"],
      localizacao:
          LatLng(json['localizacao']['lat'], json['localizacao']['lng']),
      estado: json["estado"],
      created_at: json['created_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['created_at']),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "nome": this.nome,
      "localizacao": {
        'lat': this.localizacao.latitude,
        'lng': this.localizacao.longitude
      },
      "estado": this.estado,
      "created_at": this.created_at!= null? this.created_at.millisecondsSinceEpoch:null,
      "updated_at": this.updated_at!= null? this.updated_at.millisecondsSinceEpoch:null,
      "deleted_at": this.deleted_at!= null? this.deleted_at.millisecondsSinceEpoch:null,
    };
  }

  @override
  String toString() {
    return 'Cidade{id: $id, nome: $nome, localizacao: $localizacao, estado: $estado}';
  }
}
