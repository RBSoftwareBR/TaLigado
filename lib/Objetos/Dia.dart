import 'package:flutter/material.dart';

class Dia {
  String rua;
  int dia;
  TimeOfDay hora_ini;
  TimeOfDay hora_fim;
  double valor_hora;

  Dia({this.rua, this.dia, this.hora_ini, this.hora_fim, this.valor_hora});

  Dia.Empty();

  factory Dia.fromJson(Map<String, dynamic> json) {
    return Dia(
      rua: json["rua"],
      dia: int.parse(json["dia"]),
      hora_ini: TimeOfDay(
          hour: json["hora_ini"]['hour'], minute: json['hora_fim']['minute']),
      hora_fim: TimeOfDay(
          hour: json["hora_fim"]['hour'], minute: json['hora_fim']['minute']),
      valor_hora: double.parse(json["valor_hora"]),
    );
  }

  @override
  String toString() {
    return 'Dia{rua: $rua, dia: $dia, hora_ini: $hora_ini, hora_fim: $hora_fim, valor_hora: $valor_hora}';
  }

  Map<String, dynamic> toJson() {
    return {
      "rua": this.rua,
      "dia": this.dia,
      "hora_ini": {'hour': hora_ini.hour, 'minute': hora_ini.minute},
      "hora_fim": {'hour': hora_fim.hour, 'minute': hora_fim.minute},
      "valor_hora": this.valor_hora,
    };
  }
}
