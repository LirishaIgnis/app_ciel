import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../servicios/conexion/bluetooth/bluetooth_service.dart';

class GameController extends ChangeNotifier {
  final GameState _gameState;
  final BluetoothService _bluetoothService;
  bool _bitOscilacion = false;
  Timer? _timerTiempoMuertoLocal;
  Timer? _timerTiempoMuertoVisitante;

  GameController(this._gameState, this._bluetoothService);

  GameState get gameState => _gameState;

  void _actualizarTrama() {
    _bitOscilacion = !_bitOscilacion;
    Uint8List trama =
        _gameState.generarTramaEstadoPartido(_bitOscilacion ? 6 : 2);
    _bluetoothService.enviarTrama(trama);
  }

  void _enviarTramaFaltas() {
    Uint8List tramaFaltas = _gameState.generarTramaFaltas(
      bitOscilacion: _bitOscilacion ? 6 : 2,
    );
    _bluetoothService.enviarTrama(tramaFaltas);
  }

  void aumentarMarcadorLocal() {
    _gameState.marcadorLocal++;
    notifyListeners();
    _actualizarTrama();
  }

  void disminuirMarcadorLocal() {
    if (_gameState.marcadorLocal > 0) {
      _gameState.marcadorLocal--;
      notifyListeners();
      _actualizarTrama();
    }
  }

  void aumentarMarcadorVisitante() {
    _gameState.marcadorVisitante++;
    notifyListeners();
    _actualizarTrama();
  }

  void disminuirMarcadorVisitante() {
    if (_gameState.marcadorVisitante > 0) {
      _gameState.marcadorVisitante--;
      notifyListeners();
      _actualizarTrama();
    }
  }

  void aumentarFaltasLocal() {
    _gameState.faltasLocal++;
    notifyListeners();
    _enviarTramaFaltas();
  }

  void disminuirFaltasLocal() {
    if (_gameState.faltasLocal > 0) {
      _gameState.faltasLocal--;
      notifyListeners();
      _enviarTramaFaltas();
    }
  }

  void aumentarFaltasVisitante() {
    _gameState.faltasVisitante++;
    notifyListeners();
    _enviarTramaFaltas();
  }

  void disminuirFaltasVisitante() {
    if (_gameState.faltasVisitante > 0) {
      _gameState.faltasVisitante--;
      notifyListeners();
      _enviarTramaFaltas();
    }
  }

  void reiniciarPeriodo() {
    _gameState.periodo = 1;
    _gameState.minutos = 0;
    _gameState.segundos = 0;
    notifyListeners();
    debugPrint("🔄 Reinicio de períodos al salir del tablero.");
  }

  void reiniciarMarcadoresYTiempo() {
    _gameState.marcadorLocal = 0;
    _gameState.marcadorVisitante = 0;
    _gameState.minutos = 0;
    _gameState.segundos = 0;
    _gameState.faltasLocal = 0;
    _gameState.faltasVisitante = 0;
    notifyListeners();
    _actualizarTrama();
  }

  void iniciarTiempoMuertoLocal() {
    if (_gameState.tiempoMuertoActivoLocal) return;

    _gameState.tiempoMuertoActivoLocal = true;
    _gameState.tiempoMuertoLocal = 60;
    notifyListeners();

    debugPrint("⏸️ Tiempo muerto activado para el equipo local.");

    _timerTiempoMuertoLocal =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameState.tiempoMuertoLocal > 0) {
        _gameState.tiempoMuertoLocal--;
      } else {
        _timerTiempoMuertoLocal?.cancel();
        debugPrint("🔔 Fin del tiempo muerto, emitiendo sonido...");
        _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoInicio(_bitOscilacion ? 6 : 2));

        Future.delayed(const Duration(seconds: 1), () {
          debugPrint("⏹️ Fin del sonido, enviando trama de finalización...");
          _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoFin(_bitOscilacion ? 6 : 2));

          Future.delayed(const Duration(milliseconds: 500), () {
            debugPrint("▶️ Retomando trama normal...");
            _gameState.tiempoMuertoActivoLocal = false;
            _actualizarTrama();
          });
        });
      }
      notifyListeners();
    });
  }

  void iniciarTiempoMuertoVisitante() {
    if (_gameState.tiempoMuertoActivoVisitante) return;

    _gameState.tiempoMuertoActivoVisitante = true;
    _gameState.tiempoMuertoVisitante = 60;
    notifyListeners();

    debugPrint("⏸️ Tiempo muerto activado para el equipo visitante.");

    _timerTiempoMuertoVisitante =
        Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameState.tiempoMuertoVisitante > 0) {
        _gameState.tiempoMuertoVisitante--;
      } else {
        _timerTiempoMuertoVisitante?.cancel();

        debugPrint("🔔 Fin del tiempo muerto, emitiendo sonido...");
        _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoInicio(_bitOscilacion ? 6 : 2));

        Future.delayed(const Duration(seconds: 1), () {
          debugPrint("⏹️ Fin del sonido, enviando trama de finalización...");
          _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoFin(_bitOscilacion ? 6 : 2));

          Future.delayed(const Duration(milliseconds: 500), () {
            debugPrint("▶️ Retomando trama normal...");
            _gameState.tiempoMuertoActivoVisitante = false;
            _actualizarTrama();
          });
        });
      }
      notifyListeners();
    });
  }
}
