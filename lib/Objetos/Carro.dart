class Carro {
  String id;
  String placa;
  String owner;
  String modelo;
  String cor;
  int R;
  int G;
  int B;

  Carro(
      {this.id,
      this.placa,
      this.owner,
      this.modelo,
      this.cor,
      this.R,
      this.G,
      this.B});

  factory Carro.fromJson(Map<String, dynamic> json) {
    return Carro(
      id: json["id"],
      placa: json["placa"],
      owner: json["owner"],
      modelo: json["modelo"],
      cor: json["cor"],
      R: int.parse(json["R"]),
      G: int.parse(json["G"]),
      B: int.parse(json["B"]),
    );
  }

  Carro.Empty();

  @override
  String toString() {
    return 'Carro{id: $id, placa: $placa, owner: $owner, modelo: $modelo, cor: $cor, R: $R, G: $G, B: $B}';
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
    };
  }
}
