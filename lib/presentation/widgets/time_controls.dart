import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';
import 'package:app_ciel/controllers/time_controller.dart';

class TimeControls extends StatelessWidget {
  final TimeController timeController;
  final GameController gameController;

  TimeControls(this.timeController, this.gameController);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: timeController.iniciarTiempo,
          child: Text("Iniciar", style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        SizedBox(width: 15),
        ElevatedButton(
          onPressed: timeController.pausarTiempo,
          child: Text("Pausar", style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
        SizedBox(width: 15),
        ElevatedButton(
          onPressed: () => _confirmarReinicio(context),
          child: Text("Reiniciar", style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          ),
        ),
      ],
    );
  }

  void _confirmarReinicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmación"),
          content: Text("¿Seguro que quieres reiniciar los marcadores?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                gameController.reiniciarMarcadoresYTiempo();
                Navigator.of(context).pop();
              },
              child: Text("Reiniciar"),
            ),
          ],
        );
      },
    );
  }
}
