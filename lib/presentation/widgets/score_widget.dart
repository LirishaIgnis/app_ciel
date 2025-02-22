import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';

class ScoreWidget extends StatelessWidget {
  final String label;
  final GameController gameController;
  final bool isLocal;

  ScoreWidget(this.label, this.gameController, this.isLocal);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(
          "${isLocal ? gameController.gameState.marcadorLocal : gameController.gameState.marcadorVisitante}",
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, color: isLocal ? Colors.blue : Colors.red),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isLocal ? gameController.aumentarMarcadorLocal : gameController.aumentarMarcadorVisitante,
              child: Text("+", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLocal ? Colors.blue : Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: isLocal ? gameController.disminuirMarcadorLocal : gameController.disminuirMarcadorVisitante,
              child: Text("-", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
