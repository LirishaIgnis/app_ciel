import 'package:app_ciel/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_ciel/controllers/game_controller.dart';
import 'package:app_ciel/controllers/time_controller.dart';
import 'package:app_ciel/servicios/conexion/bluetooth/bluetooth_service.dart';

class GameView extends StatefulWidget {
  @override
  _GameViewState createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final gameController = Provider.of<GameController>(context);
    final timeController = Provider.of<TimeController>(context);
    final bluetoothService = Provider.of<BluetoothService>(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue[300],
        title: const Text("Marcador", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 30),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: BluetoothMenu(bluetoothService: bluetoothService),
      backgroundColor: Colors.black, // 🔹 Se mantiene el fondo oscuro para mayor contraste
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🕒 Sección del Reloj (Centrado y con espacio inferior)
            ClockWidget(timeController),
            const SizedBox(height: 20), 

            // 📌 Sección de Equipos y Marcador (Compacto)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TeamInfoWidget(isLocal: true, isDarkBackground: true),
                      ScoreWidget("Local", gameController, true),
                    ],
                  ),
                ),
                PeriodWidget(gameController, timeController),
                Expanded(
                  child: Column(
                    children: [
                      TeamInfoWidget(isLocal: false, isDarkBackground: true),
                      ScoreWidget("Visitante", gameController, false),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), 

            // 🚨 Sección de Faltas (Centrada)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FoulsWidget(gameController, true),
                FoulsWidget(gameController, false),
              ],
            ),
            const SizedBox(height: 20),

            // ⏳ Sección de Tiempos Muertos
            TimeoutWidget(gameController),
            const SizedBox(height: 20),

            // 🎮 Controles de Tiempo
            TimeControls(timeController, gameController),
          ],
        ),
      ),
      
      // 🔙 Botón de regreso al Home
      floatingActionButton: FloatingActionButton(
        heroTag: "homeButton",
        onPressed: () {
          Navigator.pop(context);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.arrow_back_ios_outlined, size: 30),
      ),
    );
  }
}

