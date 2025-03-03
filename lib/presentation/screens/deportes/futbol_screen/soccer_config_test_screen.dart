import 'package:app_ciel/servicios/data/sports_config_service.dart';
import 'package:flutter/material.dart';

class SoccerConfigTestScreen extends StatefulWidget {
  const SoccerConfigTestScreen({super.key});

  @override
  State<SoccerConfigTestScreen> createState() => _SoccerConfigTestScreenState();
}

class _SoccerConfigTestScreenState extends State<SoccerConfigTestScreen> {
  final SportsConfigService _configService = SportsConfigService();
  Map<String, dynamic>? _config;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _configService.getConfig("soccer");
    setState(() {
      _config = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Fútbol')),
      body: _config == null
          ? const Center(child: CircularProgressIndicator()) // Cargando datos
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Duración de los Tiempos: ${_config!["time_per_half"]} minutos',
                      style: const TextStyle(fontSize: 18)),
                  Text('Tiempo Extra: ${_config!["extra_time_enabled"] ? "Habilitado" : "Deshabilitado"}',
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
