class Funcionario {
  String user;
  String cidade;
  int permissao;
  bool trabalhando;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;

  Funcionario(
      {this.user,
      this.cidade,
      this.permissao,
      this.trabalhando,
      this.created_at,
      this.updated_at,
      this.deleted_at});

  Funcionario.Empty();

  factory Funcionario.fromJson(Map<String, dynamic> json) {
    return Funcionario(
      user: json["user"],
      cidade: json["cidade"],
      permissao: int.parse(json["permissao"]),
      trabalhando: json["trabalhando"].toLowerCase() == 'true',
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
      "user": this.user,
      "cidade": this.cidade,
      "permissao": this.permissao,
      "trabalhando": this.trabalhando,
      "created_at": this.created_at.millisecondsSinceEpoch,
      "updated_at": this.updated_at.millisecondsSinceEpoch,
      "deleted_at": this.deleted_at.millisecondsSinceEpoch,
    };
  }

  @override
  String toString() {
    return 'Funcionario{user: $user, cidade: $cidade, permissao: $permissao, trabalhando: $trabalhando, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at}';
  }
}
