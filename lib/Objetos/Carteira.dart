class Carteira {
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String owner;
  String id;
  double saldo;

  Carteira(
      {this.created_at,
      this.updated_at,
      this.deleted_at,
      this.owner,
      this.saldo,
      this.id});

  Carteira.Empty();

  factory Carteira.fromJson(Map<String, dynamic> json) {
    return Carteira(
        created_at: json['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['created_at']),
        updated_at: json['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['updated_at']),
        deleted_at: json['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json['deleted_at']),
        owner: json["owner"],
        saldo: double.parse(json["saldo"]),
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      "created_at": this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at.millisecondsSinceEpoch,
      "owner": this.owner,
      "saldo": this.saldo,
      'id': this.id
    };
  }

  @override
  String toString() {
    return 'Carteira{created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, owner: $owner, id: $id, saldo: $saldo}';
  }
}
