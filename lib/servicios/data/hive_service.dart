import 'package:hive/hive.dart';
import 'package:app_ciel/models/team_model.dart';

class HiveService {
  static const String _boxName = "teamsBox";

  //  Inicializar Hive y abrir la caja
  static Future<void> init() async {
    await Hive.openBox<Team>(_boxName);
  }

  //  Guardar equipos en Hive
  static Future<void> saveTeams(Team team1, Team team2) async {
    final box = Hive.box<Team>(_boxName);
    await box.put('team1', team1);
    await box.put('team2', team2);
  }

  //  Obtener los equipos guardados
  static Team? getTeam1() {
    final box = Hive.box<Team>(_boxName);
    return box.get('team1');
  }

  static Team? getTeam2() {
    final box = Hive.box<Team>(_boxName);
    return box.get('team2');
  }
}
