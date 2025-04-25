import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';

class TimeoutWidget extends StatelessWidget {
  final GameController gameController;

  const TimeoutWidget(this.gameController, {super.key, required bool isLocal});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Time Out Local
          Row(
            children: [
              ElevatedButton(
                onPressed: gameController.iniciarTiempoMuertoLocal,
                child: const Text("Time Out Local"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(width: 10),
              if (gameController.gameState.tiempoMuertoActivoLocal)
                Text(
                  "${gameController.gameState.tiempoMuertoLocal}s",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(blurRadius: 6, color: Colors.green, offset: Offset(0, 0)),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(width: 40),

          // Time Out Visitante
          Row(
            children: [
              if (gameController.gameState.tiempoMuertoActivoVisitante)
                Text(
                  "${gameController.gameState.tiempoMuertoVisitante}s",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(blurRadius: 6, color: Colors.red, offset: Offset(0, 0)),
                    ],
                  ),
                ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: gameController.iniciarTiempoMuertoVisitante,
                child: const Text("Time Out Visitante"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

