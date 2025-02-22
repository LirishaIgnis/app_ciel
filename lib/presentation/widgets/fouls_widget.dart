import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';

class FoulsWidget extends StatelessWidget {
  final GameController gameController;
  final bool isLocal;

  const FoulsWidget(this.gameController, this.isLocal, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          isLocal ? "Faltas Local" : "Faltas Visitante",
          style: TextStyle(fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          isLocal ? "${gameController.gameState.faltasLocal}" : "${gameController.gameState.faltasVisitante}",
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: isLocal ? Colors.blue : Colors.red),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isLocal ? gameController.aumentarFaltasLocal : gameController.aumentarFaltasVisitante,
              child: Text("+", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: isLocal ? Colors.blue : Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: isLocal ? gameController.disminuirFaltasLocal : gameController.disminuirFaltasVisitante,
              child: Text("-", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
