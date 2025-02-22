import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/time_controller.dart';

class ClockWidget extends StatelessWidget {
  final TimeController timeController;

  ClockWidget(this.timeController);

  @override
  Widget build(BuildContext context) {
    return Text(
      "${timeController.gameState.minutos}:${timeController.gameState.segundos.toString().padLeft(2, '0')}",
      style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
