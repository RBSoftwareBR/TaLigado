class Cartao {
  int id;
  int id_user;
  int expiration_month;
  int expiration_year;
  String number;
  int cvc;
  String hash;
  int R;
  int G;
  int B;
  DateTime created_at;
  DateTime updated_at;
  DateTime deleted_at;
  String owner;

  bool isSelected;

  @override
  String toString() {
    return 'Cartao{id: $id, id_user: $id_user, expiration_month: $expiration_month, expiration_year: $expiration_year, number: $number, cvc: $cvc, hash: $hash, R: $R, G: $G, B: $B, created_at: $created_at, updated_at: $updated_at, deleted_at: $deleted_at, owner: $owner}';
  }

  Cartao({
    this.id,
    this.id_user,
    this.expiration_month,
    this.expiration_year,
    this.number,
    this.cvc,
    this.hash,
    this.R,
    this.G,
    this.B,
    this.created_at,
    this.updated_at,
    this.deleted_at,
    this.owner,
  });

  Cartao.Empty();

  Cartao.fromJson(Map<String, dynamic> json) {
    this.id = int.parse(json['id']);
    this.id_user = json['id_user'] == null
        ? json['user_id'] != null ? int.parse(json['user_id']) : null
        : int.parse(json['id_user']);
    this.expiration_month = int.parse(json['expiration_month']);
    this.expiration_year = int.parse(json['expiration_year']);
    this.number = json['number'];
    this.cvc = int.parse(json['cvc']);
    this.hash = json['hash'];
    this.R = int.parse(json['R']);
    this.G = int.parse(json['G']);
    this.B = int.parse(json['B']);
    this.created_at =
        json['created_at'] == null ? null : DateTime.parse(json['created_at']);
    this.updated_at =
        json['updated_at'] == null ? null : DateTime.parse(json['updated_at']);
    this.deleted_at =
        json['deleted_at'] == null ? null : DateTime.parse(json['deleted_at']);
    this.owner = json['owner'] == null
        ? json['owner'] != null ? json['owner'] : null
        : json['owner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['id_user'] = this.id_user;
    data['expiration_month'] = this.expiration_month;
    data['expiration_year'] = this.expiration_year;
    data['number'] = this.number;
    data['cvc'] = this.cvc;
    data['hash'] = this.hash;
    data['R'] = this.R;
    data['G'] = this.G;
    data['B'] = this.B;
    data['created_at'] = this.created_at;
    data['updated_at'] = this.updated_at;
    data['deleted_at'] = this.deleted_at;
    data['owner'] = this.owner;
    return data;
  }
}
