import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';

class ScoreWidget extends StatelessWidget {
  final String label;
  final GameController gameController;
  final bool isLocal;

  const ScoreWidget(this.label, this.gameController, this.isLocal, {super.key, required int fontSize});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "${isLocal ? gameController.gameState.marcadorLocal : gameController.gameState.marcadorVisitante}",
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: isLocal ? Colors.greenAccent : Colors.redAccent,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: isLocal ? Colors.green : Colors.red,
                  offset: Offset(0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isLocal
                    ? gameController.aumentarMarcadorLocal
                    : gameController.aumentarMarcadorVisitante,
                child: const Text("+", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLocal ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: isLocal
                    ? gameController.disminuirMarcadorLocal
                    : gameController.disminuirMarcadorVisitante,
                child: const Text("-", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

