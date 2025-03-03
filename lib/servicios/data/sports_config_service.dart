import 'package:hive/hive.dart';

class SportsConfigService {
  static const String _boxName = "sportsConfig";

  static Box? _box;

  /// 🔹 Inicializa Hive y abre la box si aún no está abierta.
  Future<void> _init() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox(_boxName);
    }
  }

  /// 🔹 Obtiene la configuración de un deporte desde Hive.
  Future<Map<String, dynamic>> getConfig(String sport) async {
    await _init();

    final rawData = _box!.get("config_$sport", defaultValue: _defaultConfigForSport(sport));
    return Map<String, dynamic>.from(rawData);
  }

  /// 🔹 Guarda la configuración de un deporte en Hive.
  Future<void> saveConfig(String sport, Map<String, dynamic> config) async {
    await _init();
    await _box!.put("config_$sport", config);
  }

  /// 🔹 Restablece la configuración de un deporte a sus valores predeterminados.
  Future<void> resetConfig(String sport) async {
    await _init();
    await _box!.put("config_$sport", _defaultConfigForSport(sport));
  }

  /// 🔹 Configuración predeterminada según el deporte.
  Map<String, dynamic> _defaultConfigForSport(String sport) {
    switch (sport) {
      case "basketball":
        return {
          "periods": 4,
          "time_per_period": 10,
          "shotClockEnabled": true
        };
      case "soccer":
        return {
          "halves": 2,
          "time_per_half": 45,
          "extra_time": 15,
          "stoppage_time_enabled": true
        };
      case "volleyball":
        return {
          "sets": 5,
          "points_per_set": 25,
          "minimum_difference": 2,
          "timeouts_per_set": 2
        };
      default:
        throw Exception("Deporte no soportado: $sport");
    }
  }
}
