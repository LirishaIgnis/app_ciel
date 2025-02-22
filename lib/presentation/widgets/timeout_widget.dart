import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';

class TimeoutWidget extends StatelessWidget {
  final GameController gameController;

  TimeoutWidget(this.gameController);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Time Out Local (Botón a la izquierda, tiempo a la derecha)
        Row(
          children: [
            ElevatedButton(
              onPressed: gameController.iniciarTiempoMuertoLocal,
              child: Text("Time Out Local"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            ),
            SizedBox(width: 10),
            if (gameController.gameState.tiempoMuertoActivoLocal)
              Text(
                "${gameController.gameState.tiempoMuertoLocal}s",
                style: TextStyle(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
          ],
        ),

        SizedBox(width: 40),

        // Time Out Visitante (Tiempo a la izquierda, botón a la derecha)
        Row(
          children: [
            if (gameController.gameState.tiempoMuertoActivoVisitante)
              Text(
                "${gameController.gameState.tiempoMuertoVisitante}s",
                style: TextStyle(fontSize: 22, color: Colors.red, fontWeight: FontWeight.bold),
              ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: gameController.iniciarTiempoMuertoVisitante,
              child: Text("Time Out Visitante"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}

