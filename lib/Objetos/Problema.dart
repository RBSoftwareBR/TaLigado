class Problema {
  String user;
  String fiscal;
  String id;
  String rua;
  String texto;
  String foto;
  bool is_valid;
  int tipo;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;

  Problema(
      {this.user,
      this.fiscal,
      this.id,
      this.rua,
      this.texto,
      this.foto,
      this.is_valid,
      this.tipo,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Problema.Empty();

  Map<String, dynamic> toJson() {
    return {
      "user": this.user,
      "fiscal": this.fiscal,
      "id": this.id,
      "rua": this.rua,
      "texto": this.texto,
      "foto": this.foto,
      "is_valid": this.is_valid,
      "tipo": this.tipo,
      "created_at": this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Problema{user: $user, fiscal: $fiscal, id: $id, rua: $rua, texto: $texto, foto: $foto, is_valid: $is_valid, tipo: $tipo, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }

  factory Problema.fromJson(Map<String, dynamic> json) {
    return Problema(
        user: json["user"],
        fiscal: json["fiscal"],
        id: json["id"],
        rua: json["rua"],
        texto: json["texto"],
        foto: json["foto"],
        is_valid: json["is_valid"].toLowerCase() == 'true',
        tipo: int.parse(json["tipo"]),
        created_at: json['created_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["created_at"]),
        updated_at: json['updated_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["updated_at"]),
        deleted_at: json['deleted_at'] == null
            ? null
            : DateTime.fromMillisecondsSinceEpoch(json["deleted_at"]));
  }
}
