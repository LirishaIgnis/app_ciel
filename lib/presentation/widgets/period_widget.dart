import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_ciel/controllers/game_controller.dart';
import 'package:app_ciel/controllers/time_controller.dart';

class PeriodWidget extends StatelessWidget {
  final GameController gameController;
  final TimeController timeController;

  const PeriodWidget(this.gameController, this.timeController, {super.key});

  @override
  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Período",
          style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          "${gameController.gameState.periodo}",
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.amberAccent,
            shadows: [Shadow(blurRadius: 6, color: Colors.amber)],
          ),
        ),
        const SizedBox(height: 4),
        ElevatedButton(
          onPressed: () {
            if (gameController.gameState.periodo < timeController.totalPeriodos) {
              timeController.siguientePeriodo();
            } else {
              _mostrarAlerta(context, gameController);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            minimumSize: const Size(0, 30),
          ),
          child: const Text("Siguiente", style: TextStyle(fontSize: 14)),
        ),
      ],
    ),
  );
}


  void _mostrarAlerta(BuildContext context, GameController gameController) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("⚠️ Fin del Partido"),
        content: const Text("El partido ha terminado. No se pueden agregar más períodos."),
        actions: [
          TextButton(
            onPressed: () {
              context.push('/deportes');
              gameController.reiniciarPeriodo();
            },
            child: const Text("Aceptar"),
          ),
        ],
      ),
    );
  }
}
