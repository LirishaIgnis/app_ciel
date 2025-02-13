import 'package:app_ciel/controllers/game_controller.dart';
import 'package:app_ciel/controllers/time_controller.dart';
import 'package:app_ciel/models/game_state.dart';
import 'package:app_ciel/servicios/conexion/bluetooth/bluetooth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



MultiProvider appProviders({required Widget child}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BluetoothService()), // Instancia de BluetoothService
      Provider(create: (_) => GameState()), // GameState no necesita ser un ChangeNotifier
      ChangeNotifierProvider(
        create: (context) => GameController(
          context.read<GameState>(), // Accedemos a GameState de manera segura
          context.read<BluetoothService>(), // Accedemos a BluetoothService de manera segura
        ),
      ),
      ChangeNotifierProvider(
        create: (context) => TimeController(
          context.read<GameState>(), // Accedemos a GameState de manera segura
          context.read<BluetoothService>(), // Accedemos a BluetoothService de manera segura
        ),
      ),
    ],
    child: child, // Este es el child que se pasa al `runApp`
  );
}

