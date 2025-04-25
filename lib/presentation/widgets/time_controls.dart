import 'package:flutter/material.dart';
import 'package:app_ciel/controllers/game_controller.dart';
import 'package:app_ciel/controllers/time_controller.dart';

class TimeControls extends StatefulWidget {
  final TimeController timeController;
  final GameController gameController;

  const TimeControls(this.timeController, this.gameController, {Key? key}) : super(key: key);

  @override
  State<TimeControls> createState() => _TimeControlsState();
}

class _TimeControlsState extends State<TimeControls> {
  bool tiempoIniciado = false;
  bool tiempoPausado = false;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!widget.timeController.configCargada)
            const Padding(
              padding: EdgeInsets.all(6.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tiempoIniciado
                  ? PopupMenuButton<String>(
                      color: Colors.grey[850],
                      icon: const Icon(Icons.timer, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'pausar') {
                          widget.timeController.pausarTiempo();
                          setState(() {
                            tiempoPausado = true;
                          });
                        } else if (value == 'reanudar') {
                          widget.timeController.iniciarTiempo();
                          setState(() {
                            tiempoPausado = false;
                          });
                        } else if (value == 'reiniciar') {
                          _confirmarReinicio(context);
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: tiempoPausado ? 'reanudar' : 'pausar',
                          child: Row(
                            children: [
                              Icon(
                                tiempoPausado ? Icons.play_arrow : Icons.pause,
                                color: tiempoPausado ? Colors.greenAccent : Colors.orange,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                tiempoPausado ? 'Reanudar' : 'Pausar',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'reiniciar',
                          child: Row(
                            children: [
                              Icon(Icons.restart_alt, color: Colors.redAccent),
                              SizedBox(width: 8),
                              Text('Reiniciar', style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    )
                  : ElevatedButton.icon(
                      onPressed: widget.timeController.configCargada
                          ? () {
                              widget.timeController.iniciarTiempo();
                              setState(() {
                                tiempoIniciado = true;
                                tiempoPausado = false;
                              });
                            }
                          : null,
                      icon: const Icon(Icons.play_arrow, color: Colors.white),
                      label: const Text("Iniciar", style: TextStyle(fontSize: 18, color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.timeController.configCargada ? Colors.greenAccent[400] : Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmarReinicio(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text("Confirmación", style: TextStyle(color: Colors.white)),
          content: const Text("¿Seguro que quieres reiniciar los marcadores?", style: TextStyle(color: Colors.white70)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancelar", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                widget.gameController.reiniciarMarcadoresYTiempo();
                setState(() {
                  tiempoIniciado = false;
                  tiempoPausado = false;
                });
                Navigator.of(context).pop();
              },
              child: const Text("Reiniciar", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
