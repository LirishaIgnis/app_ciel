import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/time_controller.dart';
import 'package:app_ciel/controllers/utils/time_formatter.dart';

class ClockWidget extends StatelessWidget {
  final TimeController timeController;

  ClockWidget(this.timeController);

  @override
  Widget build(BuildContext context) {
    final duracion = timeController.duracionRestante;
    final tiempoFormateado = formatDuration(duracion);

    return Text(
      tiempoFormateado,
      style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white),
    );
  }
}
