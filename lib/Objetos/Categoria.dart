import 'package:flutter/material.dart';

class Categoria{
  String id;
  String name;
  IconData icon;
  Color color;

  Categoria({this.id, this.name, this.icon, this.color});

  @override
  String toString() {
    return 'Categoria{id: $id, name: $name, icon: $icon, color: $color}';
  }

  Categoria.fromJson( json)
      : id = json['id'],
        name = json['name'],
        icon = json['icon'],
        color = json['color'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
      };



}