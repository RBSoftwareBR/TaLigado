import 'package:json_annotation/json_annotation.dart';

part 'UserDispostivo.g.dart';

@JsonSerializable()
class UserDispositivo {
  String id;
  String id_user;
  String firebase_key;
  String device;
  String model;
  String product;
  String serial;
  String manufacturer;
  factory UserDispositivo.fromJson(Map<String, dynamic> json) =>
      _$UserDispositivoFromJson(json);
  UserDispositivo(this.id, this.id_user, this.firebase_key, this.device,
      this.model, this.product, this.serial, this.manufacturer);

  Map<String, dynamic> UserDispositivoToJson() => <String, String>{
        'id': id,
        'id_user': id_user,
        'firebase_key': firebase_key,
        'device': device,
        'model': model,
        'product': product,
        'serial': serial,
        'manufacturer': manufacturer
      };

  @override
  String toString() {
    return 'UserDispositivo{id: $id, id_user: $id_user, firebase_key: $firebase_key, device: $device, model: $model, product: $product, serial: $serial, manufacturer: $manufacturer}';
  }
}
