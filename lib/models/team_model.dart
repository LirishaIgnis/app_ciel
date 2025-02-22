import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'team_model.g.dart'; // Archivo generado automáticamente por Hive

@HiveType(typeId: 0)
class Team extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String acronym;

  @HiveField(2)
  final int primaryColor; // Guardamos los colores como int

  @HiveField(3)
  final int secondaryColor;

  Team({
    required this.name,
    required this.acronym,
    required this.primaryColor,
    required this.secondaryColor,
  });

  // Métodos para obtener los colores como Color en Flutter
  Color getPrimaryColor() => Color(primaryColor);
  Color getSecondaryColor() => Color(secondaryColor);
}
