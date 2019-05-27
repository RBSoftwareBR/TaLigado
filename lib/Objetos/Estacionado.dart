class Estacionado {
  String id;
  String rua;
  String user;
  String responsavel;
  String transacao;
  String cidade;
  DateTime data_entrada;
  DateTime data_saida;

  Estacionado(
      {this.id,
      this.rua,
      this.user,
      this.responsavel,
      this.transacao,
      this.cidade,
      this.data_entrada,
      this.data_saida});

  Estacionado.Empty();

  @override
  String toString() {
    return 'Estacionado{id: $id, rua: $rua, user: $user, responsavel: $responsavel, transacao: $transacao, cidade: $cidade, data_entrada: $data_entrada, data_saida: $data_saida}';
  }

  factory Estacionado.fromJson(Map<String, dynamic> json) {
    return Estacionado(
      id: json["id"],
      rua: json["rua"],
      user: json["user"],
      responsavel: json["responsavel"],
      transacao: json["transacao"],
      cidade: json["cidade"],
      data_entrada: DateTime.fromMillisecondsSinceEpoch(json["data_entrada"]),
      data_saida: DateTime.fromMillisecondsSinceEpoch(json["data_saida"]),
    );
  }
}
