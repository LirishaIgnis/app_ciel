import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../servicios/conexion/bluetooth/bluetooth_service.dart';
import '../controllers/game_controller.dart';
import '../servicios/data/sports_config_service.dart';
import '../servicios/data/hive_service.dart';

class TimeController extends ChangeNotifier {
  final GameState _gameState;
  final BluetoothService _bluetoothService;
  final SportsConfigService _configService = SportsConfigService();

  Timer? _tramaTimer;
  Timer? _relojTimer;
  bool _bitOscilacion = false;

  int _duracionPeriodo = 10;
  int _totalPeriodos = 4;
  int _periodoActual = 1;

  bool _configCargada = false; 

  TimeController(this._gameState, this._bluetoothService);

  GameState get gameState => _gameState;
  bool get configCargada => _configCargada;
  int get duracionPeriodo => _duracionPeriodo;
  int get periodoActual => _periodoActual;
  int get totalPeriodos => _totalPeriodos;

  /// **Carga la configuración del deporte actual antes de iniciar el tiempo**
  Future<void> cargarConfiguracion(String deporte) async {
    debugPrint("📢 Intentando cargar configuración para: $deporte...");

    final config = await _configService.getConfig(deporte);

    switch (deporte) {
      case "basketball":
        _duracionPeriodo = config["time_per_period"] ?? 10;
        _totalPeriodos = config["periods"] ?? 4;
        break;
      case "soccer":
        _duracionPeriodo = config["time_per_half"] ?? 45;
        _totalPeriodos = 2;
        break;
      case "volleyball":
        _duracionPeriodo = config["points_per_set"] ?? 25; 
        _totalPeriodos = config["sets"] ?? 5;
        break;
      default:
        debugPrint("⚠️ Deporte desconocido: $deporte. Se usará configuración predeterminada.");
    }

    _gameState.minutos = _duracionPeriodo;
    _gameState.segundos = 0;
    _periodoActual = 1;
    _configCargada = true;

    debugPrint("✅ Configuración cargada: $_duracionPeriodo minutos, $_totalPeriodos períodos.");

    // 🔹 Obtener nombres desde Hive y enviarlos
    final teamLocal = HiveService.getTeam1();
    final teamVisitante = HiveService.getTeam2();

    final String nombreLocal = teamLocal?.name ?? "LOCAL";
    final String nombreVisitante = teamVisitante?.name ?? "VISITANTE";

    debugPrint("📡 Enviando nombres de equipos...");
    _bluetoothService.enviarTrama(_gameState.generarTramaNombreEquipo(esLocal: true, nombreEquipo: nombreLocal));
    Future.delayed(const Duration(milliseconds: 500), () {
      _bluetoothService.enviarTrama(_gameState.generarTramaNombreEquipo(esLocal: false, nombreEquipo: nombreVisitante));
    });  

    debugPrint("✅ Configuración cargada, nombres enviados y partido iniciado.");

    notifyListeners();
}


  void iniciarTiempo() {
    debugPrint("📢 Intentando iniciar tiempo...");

    if (!_configCargada) {
      debugPrint("❌ ERROR: No se ha cargado la configuración antes de iniciar el tiempo.");
      return;
    }

    if (_tramaTimer == null && _relojTimer == null) {
      if (_gameState.minutos == 0 && _gameState.segundos == 0) {
        _gameState.minutos = _duracionPeriodo;
        _gameState.segundos = 0;
        debugPrint("🔄 Reiniciando el tiempo a $_duracionPeriodo minutos.");
      } else {
        debugPrint("▶️ Reanudando el tiempo desde ${_gameState.minutos}:${_gameState.segundos}.");
      }

      _tramaTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _enviarTrama();
      });

      _relojTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _actualizarTiempo();
      });

      debugPrint("✅ Tiempo iniciado.");
    }
  }

  void pausarTiempo() {
    _tramaTimer?.cancel();
    _tramaTimer = null;
    _relojTimer?.cancel();
    _relojTimer = null;
  }

  void reiniciarTiempo(GameController gameController) {
    _tramaTimer?.cancel();
    _relojTimer?.cancel();
    _tramaTimer = null;
    _relojTimer = null;

    _gameState.minutos = _duracionPeriodo;
    _gameState.segundos = 0;
    _periodoActual = 1;

    gameController.reiniciarMarcadoresYTiempo();
    debugPrint("⏳ Tiempo reiniciado a $_duracionPeriodo minutos.");

    notifyListeners();
  }

  void _actualizarTiempo() {
    if (_gameState.tiempoMuertoActivoLocal || _gameState.tiempoMuertoActivoVisitante) {
      debugPrint("⏸️ Tiempo pausado: Tiempo muerto en curso.");
      return;
    }

    if (_gameState.minutos == 0 && _gameState.segundos == 0) {
      if (_periodoActual < _totalPeriodos) {
        _periodoActual++;
        _gameState.minutos = _duracionPeriodo;
        _gameState.segundos = 0;
        debugPrint("🔄 Nuevo período $_periodoActual de $_totalPeriodos. Reiniciando a $_duracionPeriodo minutos.");
      } else {
        debugPrint("⚠️ No se puede avanzar. Ya se alcanzó el período máximo: $_totalPeriodos.");
        pausarTiempo(); // ✅ Asegurar que el tiempo se detiene al alcanzar el límite
      }
    } else {
      if (_gameState.segundos == 0) {
        _gameState.minutos--;
        _gameState.segundos = 59;
      } else {
        _gameState.segundos--;
      }
    }

    notifyListeners();
}


  void _enviarTrama() {
    _bitOscilacion = !_bitOscilacion;
    Uint8List trama = _gameState.generarTramaEstadoPartido(_bitOscilacion ? 6 : 2);
    _bluetoothService.enviarTrama(trama);
  }
}

