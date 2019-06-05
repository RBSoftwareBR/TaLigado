class Carro {
  String id;
  String placa;
  String owner;
  String modelo;
  String cor;
  int R;
  int G;
  int B;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;

  Carro(
      {this.id,
      this.placa,
      this.owner,
      this.modelo,
      this.cor,
      this.R,
      this.G,
      this.B,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Carro.fromJson(json) {
    this.id = json["id"];
    this.placa = json["placa"];
    this.owner = json["owner"];
    this.modelo = json["modelo"];
    this.cor = json["cor"];
    this.R = json["R"];
    this.G = json["G"];
    this.B = json["B"];
    this.created_at = json['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['created_at']);
    this.updated_at = json['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['updated_at']);
    this.deleted_at = json['deleted_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']);
  }

  Carro.Empty();

  @override
  String toString() {
    return 'Carro{id: $id, placa: $placa, owner: $owner, modelo: $modelo, cor: $cor, R: $R, G: $G, B: $B, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "placa": this.placa,
      "owner": this.owner,
      "modelo": this.modelo,
      "cor": this.cor,
      "R": this.R,
      "G": this.G,
      "B": this.B,
      'created_at': this.created_at == null
          ? null
          : this.created_at.millisecondsSinceEpoch,
      'updated_at': this.updated_at == null
          ? null
          : this.updated_at.millisecondsSinceEpoch,
      'deleted_at': this.deleted_at == null
          ? null
          : this.deleted_at.millisecondsSinceEpoch
    };
  }
}
