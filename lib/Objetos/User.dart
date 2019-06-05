import 'package:kivaga/Objetos/Cartao.dart';

class User {
  String id;
  String nome;
  DateTime data_nascimento;
  String celular;
  String cpf;
  String email;
  String senha;
  int strike;
  String identidade;
  String identidade_expedidor;
  DateTime identidade_data_expedicao;
  int permissao;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String remember_token;
  List<Cartao> cartoes;
  bool isEmailVerified;
  String tipo;
  String foto;

  var example = {
    "id": "124",
    "nome": "Renato Bosa",
    "data_nascimento": "1992-04-15 00:00:00",
    "celular": "(42) 9 9931-9375",
    "cpf": "083.668.949-67",
    "email": "vergil009@hotmail.com",
    "senha": "cf7fb946251d266391dece237e4e1155",
    "strike": "0",
    "identidade": "1123123123",
    "identidade_expedidor": "PR",
    "identidade_data_expedicao": "1992-04-15 00:00:00",
    "permissao": null,
    "created_at": null,
    "updated_at": null,
    "deleted_at": null,
    "remember_token": null,
    "enderecos": [
      {
        "id": "16",
        "id_user": "124",
        "cidade": "Castro",
        "cep": "84178-470",
        "bairro": "Cantagalo",
        "endereco": "Rua Pedro Canha Salgado",
        "numero": "87",
        "complemento": "",
        "lat": "-24.8153262",
        "lng": "-50.0001578",
        "created_at": "2019-01-28 14:53:50",
        "updated_at": "2019-01-28 14:53:50",
        "deleted_at": null
      }
    ],
    "cartoes": [
      {
        "id": "1",
        "id_user": "124",
        "expiration_month": "10",
        "expiration_year": "2022",
        "number": "5292 0500 1263 9481",
        "cvc": "827",
        "hash": "  ",
        "R": "198",
        "G": "40",
        "B": "40",
        "created_at": "2019-01-28 17:33:06",
        "updated_at": "2019-01-28 17:33:06",
        "deleted_at": null,
        "owner_name": "Renato Bosa"
      }
    ]
  };

  User.Empty() {
    strike = 0;
    permissao = 0;
  }

  User(
      {this.id,
      this.nome,
      this.data_nascimento,
      this.celular,
      this.cpf,
      this.email,
      this.senha,
      this.strike,
      this.identidade,
      this.identidade_expedidor,
      this.identidade_data_expedicao,
      this.permissao,
      this.created_at,
      this.updated_at,
      this.deleted_at,
      this.remember_token,
      this.cartoes,
      this.tipo,
      this.foto});

  User.fromJson(j) {
    print('CHEGOU AQUI ');
    this.id = j['id'] == null ? null : j['id'];
    this.nome = j['nome'] == null ? null : j['nome'];
    this.data_nascimento = j['data_nascimento'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['data_nascimento']);
    this.celular = j['celular'] == null ? null : j['celular'];
    this.cpf = j['cpf'] == null ? null : j['cpf'];
    this.email = j['email'] == null ? null : j['email'];
    this.senha = j['senha'] == null ? null : j['senha'];
    this.strike = j['strike'] == null ? null : j['strike'];
    this.identidade = j['identidade'] == null ? null : j['identidade'];
    this.identidade_expedidor =
        j['identidade_expedidor'] == null ? null : j['identidade_expedidor'];
    this.identidade_data_expedicao = j['identidade_data_expedicao'] == null
        ? null
        : DateTime.parse(j['identidade_data_expedicao']);
    this.permissao = j['permissao'] == null ? null : j['permissao'];
    this.created_at = j['created_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['created_at']);
    this.updated_at = j['updated_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['updated_at']);
    this.deleted_at = j['deleted_at'] == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(j['deleted_at']);
    this.remember_token =
        j['remember_token'] == null ? null : j['remember_token'];
    this.cartoes = (j['cartoes'] as List) != null
        ? (j['cartoes'] as List).map((i) => Cartao.fromJson(i)).toList()
        : null;
    this.isEmailVerified =
        j['isEmailVerified'] == null ? null : j['isEmailVerified'];
    this.tipo = j['tipo'] == null ? null : j['tipo'];
    this.foto = j['foto'] == null ? null : j['foto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nome'] = this.nome;
    data['data_nascimento'] = this.data_nascimento != null
        ? this.data_nascimento.millisecondsSinceEpoch
        : null;
    data['celular'] = this.celular;
    data['cpf'] = this.cpf;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['permissao'] = this.permissao;
    data['created_at'] =
        this.created_at != null ? this.created_at.millisecondsSinceEpoch : null;
    data['updated_at'] =
        this.updated_at != null ? this.updated_at.millisecondsSinceEpoch : null;
    data['deleted_at'] =
        this.deleted_at != null ? this.deleted_at.millisecondsSinceEpoch : null;
    data['remember_token'] = this.remember_token;
    data['isEmailVerified'] = this.isEmailVerified;
    data['tipo'] = this.tipo;
    data['foto'] = this.foto;
    data['cartoes'] = this.cartoes != null
        ? this.cartoes.map((i) => i.toJson()).toList()
        : null;

    return data;
  }

  @override
  String toString() {
    return 'User{id: $id, nome: $nome, data_nascimento: $data_nascimento, tipo: $tipo, celular: $celular, cpf: $cpf, email: $email, senha: $senha, strike: $strike, identidade: $identidade, identidade_expedidor: $identidade_expedidor, identidade_data_expedicao: $identidade_data_expedicao, permissao: $permissao, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, remember_token: $remember_token, cartoes: $cartoes, isEmailVerified: $isEmailVerified}';
  }
}
