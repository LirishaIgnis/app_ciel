import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';
import 'package:app_ciel/controllers/time_controller.dart';

class TimeControls extends StatelessWidget {
  final TimeController timeController;
  final GameController gameController;

  const TimeControls(this.timeController, this.gameController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!timeController.configCargada)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(), // ⏳ Indica que la configuración está cargando
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: timeController.configCargada ? timeController.iniciarTiempo : null, // ❌ Bloquea si no está cargado
              child: const Text("Iniciar", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: timeController.configCargada ? Colors.green : Colors.grey, // 🔹 Deshabilitado si no hay config
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: timeController.pausarTiempo,
              child: const Text("Pausar", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
            const SizedBox(width: 15),
            ElevatedButton(
              onPressed: () => _confirmarReinicio(context),
              child: const Text("Reiniciar", style: TextStyle(fontSize: 20)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _confirmarReinicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmación"),
          content: const Text("¿Seguro que quieres reiniciar los marcadores?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                gameController.reiniciarMarcadoresYTiempo();
                Navigator.of(context).pop();
              },
              child: const Text("Reiniciar"),
            ),
          ],
        );
      },
    );
  }
}
