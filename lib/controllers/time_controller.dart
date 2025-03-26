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
  bool _esperandoInicio = false;
  bool _enUltimoMinuto = false;
  bool _tiempoFinalizado = false;

  Duration _duracionRestante = Duration();

  TimeController(this._gameState, this._bluetoothService);

  GameState get gameState => _gameState;
  bool get configCargada => _configCargada;
  int get duracionPeriodo => _duracionPeriodo;
  int get periodoActual => _periodoActual;
  int get totalPeriodos => _totalPeriodos;
  bool get esperandoInicio => _esperandoInicio;
  bool get tiempoFinalizado => _tiempoFinalizado;
  Duration get duracionRestante => _duracionRestante;

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
    _duracionRestante = Duration(minutes: _duracionPeriodo);
    _periodoActual = 1;
    _configCargada = true;
    _esperandoInicio = false;
    _tiempoFinalizado = false;

    final teamLocal = HiveService.getTeam1();
    final teamVisitante = HiveService.getTeam2();

    final String nombreLocal = teamLocal?.name ?? "LOCAL";
    final String nombreVisitante = teamVisitante?.name ?? "VISITANTE";

    debugPrint("📡 Enviando nombres de equipos...");
    _bluetoothService.enviarTrama(_gameState.generarTramaNombreEquipo(esLocal: true, nombreEquipo: nombreLocal));
    Future.delayed(const Duration(milliseconds: 500), () {
      _bluetoothService.enviarTrama(_gameState.generarTramaNombreEquipo(esLocal: false, nombreEquipo: nombreVisitante));
    });

    debugPrint("✅ Configuración cargada, nombres enviados y partido listo para iniciar.");
    notifyListeners();
  }

  void iniciarTiempo() {
    debugPrint("📢 Intentando iniciar tiempo...");

    if (!_configCargada) {
      debugPrint("❌ ERROR: No se ha cargado la configuración antes de iniciar el tiempo.");
      return;
    }

    if (_esperandoInicio) {
      _esperandoInicio = false;
      debugPrint("▶️ Iniciando nuevo período $_periodoActual.");
    }

    if (_tramaTimer == null && _relojTimer == null && !_tiempoFinalizado) {
      debugPrint("▶️ Reanudando el tiempo desde ${_gameState.minutos}:${_gameState.segundos}.");

      final segundosTotales = _gameState.minutos * 60 + _gameState.segundos;
      _duracionRestante = Duration(seconds: segundosTotales);

      _tramaTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
        _enviarTrama();
      });

      _relojTimer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        _actualizarTiempoPreciso();
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
    _duracionRestante = Duration(minutes: _duracionPeriodo);
    _periodoActual = 1;
    _esperandoInicio = false;
    _tiempoFinalizado = false;
    _enUltimoMinuto = false;

    gameController.reiniciarMarcadoresYTiempo();
    debugPrint("⏳ Tiempo reiniciado a $_duracionPeriodo minutos.");

    notifyListeners();
  }

  void siguientePeriodo() {
    if (_periodoActual >= _totalPeriodos) return;

    _periodoActual++;
    _gameState.periodo = _periodoActual;
    _gameState.minutos = _duracionPeriodo;
    _gameState.segundos = 0;
    _duracionRestante = Duration(minutes: _duracionPeriodo);
    _esperandoInicio = false;
    _enUltimoMinuto = false;
    _tiempoFinalizado = false;

    debugPrint("🔁 Se cargó el período $_periodoActual con $_duracionPeriodo minutos.");
    notifyListeners();
  }

  void _actualizarTiempoPreciso() {
    if (_gameState.tiempoMuertoActivoLocal || _gameState.tiempoMuertoActivoVisitante) {
      debugPrint("⏸️ Tiempo pausado: Tiempo muerto en curso.");
      return;
    }

    if (_duracionRestante <= Duration.zero) {
      _duracionRestante = Duration.zero;
      _tiempoFinalizado = true;
      _activarAlertaFinTiempo();
      notifyListeners();
      return;
    }

    _duracionRestante -= Duration(milliseconds: 10);

    final totalSeconds = _duracionRestante.inSeconds;
    if (totalSeconds < 60) {
      _enUltimoMinuto = true;
    }

    _gameState.minutos = _duracionRestante.inMinutes;
    _gameState.segundos = _duracionRestante.inSeconds % 60;

    notifyListeners();
  }

  void _activarAlertaFinTiempo() {
    debugPrint("🔔 Enviando alerta sonora de fin de tiempo...");
    _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoInicio(_bitOscilacion ? 6 : 2));
    pausarTiempo();
  }

  void _enviarTrama() {
    _bitOscilacion = !_bitOscilacion;
    Uint8List trama;

    if (_enUltimoMinuto) {
      trama = _gameState.generarTramaTiempoMenorUnMinuto(_bitOscilacion ? 6 : 2);
      debugPrint("📡 Enviando TRAMA de MENOS de 1 minuto.");
    } else {
      trama = _gameState.generarTramaEstadoPartido(_bitOscilacion ? 6 : 2);
      debugPrint("📡 Enviando TRAMA ESTÁNDAR.");
    }

    _bluetoothService.enviarTrama(trama);
  }
}
