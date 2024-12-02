import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Cards {
  final String id; // Identificador único
  String label;
  Color color;
  String pictogram;
  bool isActive;

  Cards(this.label, this.color, this.pictogram, {this.isActive = true})
      : id = const Uuid().v4(); // Gera um ID único ao criar o card

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cards &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
