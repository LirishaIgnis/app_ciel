import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/game_state.dart';
import '../servicios/conexion/bluetooth/bluetooth_service.dart';

class GameController extends ChangeNotifier {
  final GameState _gameState;
  final BluetoothService _bluetoothService;
  bool _bitOscilacion = false; // Alterna entre 6 y 2
  Timer? _timerTiempoMuertoLocal;
  Timer? _timerTiempoMuertoVisitante;

  GameController(this._gameState, this._bluetoothService);

  GameState get gameState => _gameState;

  /// **Actualiza y envía la trama estándar**
  void _actualizarTrama() {
    _bitOscilacion = !_bitOscilacion; // Alternar entre 6 y 2
    Uint8List trama = _gameState.generarTramaEstadoPartido(_bitOscilacion ? 6 : 2);
    _bluetoothService.enviarTrama(trama);
  }

  /// **Genera y envía la trama de faltas**
  void _enviarTramaFaltas() {
    Uint8List tramaFaltas = _gameState.generarTramaFaltas(
      bitOscilacion: _bitOscilacion ? 6 : 2,
    );
    _bluetoothService.enviarTrama(tramaFaltas);
  }

  // *** Funciones para modificar el marcador ***
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

  // *** Funciones para modificar las faltas ***
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

  // *** Función para cambiar el periodo ***
  void cambiarPeriodo() {
    _gameState.periodo++;
    _gameState.minutos = 0;
    _gameState.segundos = 0;
    notifyListeners();
    _actualizarTrama();
  }

  // *** Función para reiniciar los marcadores y el tiempo ***
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

  // *** 🚀 IMPLEMENTACIÓN DEL TIEMPO MUERTO ***

  /// **Inicia el tiempo muerto para el equipo local**
  void iniciarTiempoMuertoLocal() {
    if (_gameState.tiempoMuertoActivoLocal) return; // Si ya está activo, no hacer nada

    _gameState.tiempoMuertoActivoLocal = true;
    _gameState.tiempoMuertoLocal = 60;
    notifyListeners();

    // Enviar la trama de inicio de sonido del tiempo muerto
    _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoInicio());

    // Iniciar el conteo regresivo del tiempo muerto
    _timerTiempoMuertoLocal = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_gameState.tiempoMuertoLocal == 59) {
        _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoFin());
      }

      if (_gameState.tiempoMuertoLocal > 0) {
        _gameState.tiempoMuertoLocal--;
      } else {
        // Al llegar a 0, finaliza el tiempo muerto y retoma la trama normal
        _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoInicio());
        Future.delayed(Duration(seconds: 1), () {
          _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoFin());
          _gameState.tiempoMuertoActivoLocal = false;
          _timerTiempoMuertoLocal?.cancel();
          _actualizarTrama();
        });
      }
      notifyListeners();
    });
  }

  /// **Inicia el tiempo muerto para el equipo visitante**
  void iniciarTiempoMuertoVisitante() {
    if (_gameState.tiempoMuertoActivoVisitante) return;

    _gameState.tiempoMuertoActivoVisitante = true;
    _gameState.tiempoMuertoVisitante = 60;
    notifyListeners();

    // Enviar la trama de inicio de sonido del tiempo muerto
    _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoInicio());

    // Iniciar el conteo regresivo del tiempo muerto
    _timerTiempoMuertoVisitante = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_gameState.tiempoMuertoVisitante == 59) {
        _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoFin());
      }

      if (_gameState.tiempoMuertoVisitante > 0) {
        _gameState.tiempoMuertoVisitante--;
      } else {
        // Al llegar a 0, finaliza el tiempo muerto y retoma la trama normal
        _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoInicio());
        Future.delayed(Duration(seconds: 1), () {
          _bluetoothService.enviarTrama(_gameState.generarTramaTiempoMuertoFin());
          _gameState.tiempoMuertoActivoVisitante = false;
          _timerTiempoMuertoVisitante?.cancel();
          _actualizarTrama();
        });
      }
      notifyListeners();
    });
  }
}
