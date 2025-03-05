import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';
import 'package:app_ciel/controllers/time_controller.dart';

class PeriodWidget extends StatelessWidget {
  final GameController gameController;
  final TimeController timeController;

  PeriodWidget(this.gameController, this.timeController);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Periodo", style: TextStyle(fontSize: 30, color: Colors.white)),
        SizedBox(height: 5),
        Text("${gameController.gameState.periodo}",
            style: TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        ElevatedButton(
          onPressed: () {
            if (gameController.gameState.periodo < timeController.totalPeriodos) {
              gameController.cambiarPeriodo(timeController);
              timeController.reiniciarTiempo(gameController);
            } else {
              _mostrarAlerta(context); // ✅ Mostrar alerta si se supera el límite
            }
          },
          child: Text("Siguiente", style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }

  /// ** Función para mostrar la alerta**
  void _mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("⚠️ Fin del Partido"),
        content: Text("El partido ha terminado. No se pueden agregar más períodos."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text("Aceptar"),
          ),
        ],
      ),
    );
  }
}

