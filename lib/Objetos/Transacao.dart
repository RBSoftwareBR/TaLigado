class Transacao {
  String id;
  String adquirente;
  String beneficiario;
  String referencia;
  double valor;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;

  Transacao(
      {this.id,
      this.adquirente,
      this.beneficiario,
      this.referencia,
      this.valor,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Transacao.Empty();

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "adquirente": this.adquirente,
      "beneficiario": this.beneficiario,
      "referencia": this.referencia,
      "valor": this.valor,
      "created_at":
          created_at == null ? null : this.created_at.millisecondsSinceEpoch,
      "updated_at":
          updated_at == null ? null : this.updated_at.millisecondsSinceEpoch,
      "deleted_at":
          deleted_at == null ? null : this.deleted_at.millisecondsSinceEpoch,
    };
  }

  factory Transacao.fromJson(Map<String, dynamic> json) {
    return Transacao(
      id: json["id"],
      adquirente: json["adquirente"],
      beneficiario: json["beneficiario"],
      referencia: json["referencia"],
      valor: json['valor'],
      created_at: json['created_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
      updated_at: json['updated_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
      deleted_at: json['deleted_at'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]),
    );
  }

  @override
  String toString() {
    return 'Transacao{id: $id,valor: $valor adquirente: $adquirente, beneficiario: $beneficiario, referencia: $referencia, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }
}
