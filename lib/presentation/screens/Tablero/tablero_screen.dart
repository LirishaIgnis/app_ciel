import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TableroScreen extends StatefulWidget {
  @override
  _TableroScreenState createState() => _TableroScreenState();
}
class _TableroScreenState extends State<TableroScreen> {
  int puntosLocal = 0;
  int puntosVisitante = 0;
  int faltasLocal = 0;
  int faltasVisitante = 0;
  int periodo = 1;

  Timer? _timer;
  int segundos = 0;
  bool enEjecucion = false;

  void iniciarTimer() {
    if (enEjecucion) return;
    enEjecucion = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          segundos++;
        });
      }
    });
  }

  void pausarTimer() {
    _timer?.cancel();
    enEjecucion = false;
  }

  void reiniciarTimer() {
    pausarTimer();
    setState(() {
      segundos = 0;
    });
  }

  void cambiarPeriodo() {
    setState(() {
      periodo++;
      reiniciarTimer();
    });
  }

  String formatearTiempo(int segundosTotales) {
    final minutos = segundosTotales ~/ 60;
    final segundos = segundosTotales % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}'
        .padLeft(5);
  }

  @override
  dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Control Tablero Deportivo',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Contador de tiempo
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Text(
                    formatearTiempo(segundos),
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade300,
                        ),
                        onPressed: iniciarTimer,
                        child: const Text('Iniciar'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade300,
                        ),
                        onPressed: pausarTimer,
                        child: const Text('Pausar'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade300,
                        ),
                        onPressed: reiniciarTimer,
                        child: const Text('Reiniciar'),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Marcador de puntos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                marcadorEquipo('LOCAL', puntosLocal, faltasLocal, true),
                Text(
                  'Periodo $periodo',
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
                marcadorEquipo('VISITANTE', puntosVisitante, faltasVisitante, false),
              ],
            ),

            const SizedBox(height: 20),

            // Controles de puntos, faltas y periodo
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      controlBotones('Puntos Local', () => setState(() {
                        // Asegurando que los puntos no sean negativos
                        puntosLocal = puntosLocal + 1;
                      }), () => setState(() {
                        // Solo resta si los puntos son mayores que 0
                        if (puntosLocal > 0) puntosLocal--;
                      })),
                      controlBotones('Puntos Visitante', () => setState(() {
                        puntosVisitante = puntosVisitante + 1;
                      }), () => setState(() {
                        // Solo resta si los puntos son mayores que 0
                        if (puntosVisitante > 0) puntosVisitante--;
                      })),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      controlBotones('Faltas Local', () => setState(() => faltasLocal++), 
                          () => setState(() => faltasLocal--)),
                      controlBotones('Faltas Visitante', 
                          () => setState(() => faltasVisitante++),
                          () => setState(() => faltasVisitante--)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Botón para cambiar el periodo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        onPressed: cambiarPeriodo,
                        child: const Text('Cambiar Periodo'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),
          ],
        ),
      ),

      // Botones flotantes con tags únicos
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: 'settings',  // Tag único para el botón de configuración
            onPressed: () => Navigator.of(context).pop(),
            elevation: 6.0,
            child: const Icon(Icons.settings, color: Colors.black),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: 'home',  // Tag único para el botón de inicio
            onPressed: () => context.go('/home'),
            elevation: 6.0,
            child: const Icon(Icons.home, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget marcadorEquipo(String titulo, int puntos, int faltas, bool esLocal) {
    return Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: esLocal ? Colors.blue[900] : Colors.red[900],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            puntos.toString(),
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Faltas: $faltas',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }

  Widget controlBotones(String titulo, VoidCallback onSumar, VoidCallback onRestar) {
    return Column(
      children: [
        Text(
          titulo,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade200,
              ),
              onPressed: onSumar,
              child: const Text('+'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade200,
              ),
              onPressed: onRestar,
              child: const Text('-'),
            ),
          ],
        ),
      ],
    );
  }
}