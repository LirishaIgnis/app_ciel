import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';

class FoulsWidget extends StatelessWidget {
  final GameController gameController;
  final bool isLocal;

  const FoulsWidget(this.gameController, this.isLocal, {Key? key, required int fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isLocal ? "Faltas Local" : "Faltas Visitante",
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isLocal
                ? "${gameController.gameState.faltasLocal}"
                : "${gameController.gameState.faltasVisitante}",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: isLocal ? Colors.greenAccent : Colors.redAccent,
              shadows: [
                Shadow(
                  blurRadius: 8,
                  color: isLocal ? Colors.green : Colors.red,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isLocal
                    ? gameController.aumentarFaltasLocal
                    : gameController.aumentarFaltasVisitante,
                child: const Text("+", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLocal ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: isLocal
                    ? gameController.disminuirFaltasLocal
                    : gameController.disminuirFaltasVisitante,
                child: const Text("-", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
