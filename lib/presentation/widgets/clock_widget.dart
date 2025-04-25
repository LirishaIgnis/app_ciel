import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/time_controller.dart';
import 'package:app_ciel/controllers/utils/time_formatter.dart';

class ClockWidget extends StatelessWidget {
  final TimeController timeController;

  const ClockWidget(this.timeController, {super.key});

  @override
  Widget build(BuildContext context) {
    final duracion = timeController.duracionRestante;
    final tiempoFormateado = formatDuration(duracion);

    return Align(
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          tiempoFormateado,
          style: const TextStyle(
            fontSize: 80,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
            letterSpacing: 3,
            shadows: [
              Shadow(
                blurRadius: 12,
                color: Colors.green,
                offset: Offset(0, 0),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
