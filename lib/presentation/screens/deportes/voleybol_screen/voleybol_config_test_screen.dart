import 'package:app_ciel/servicios/data/sports_config_service.dart';
import 'package:flutter/material.dart';

class VolleyballConfigTestScreen extends StatefulWidget {
  const VolleyballConfigTestScreen({super.key});

  @override
  State<VolleyballConfigTestScreen> createState() => _VolleyballConfigTestScreenState();
}

class _VolleyballConfigTestScreenState extends State<VolleyballConfigTestScreen> {
  final SportsConfigService _configService = SportsConfigService();
  Map<String, dynamic>? _config;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _configService.getConfig("volleyball");
    setState(() {
      _config = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Vóleybol')),
      body: _config == null
          ? const Center(child: CircularProgressIndicator()) // Cargando datos
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Número de Sets: ${_config!["sets"]}', style: const TextStyle(fontSize: 18)),
                  Text('Puntos por Set: ${_config!["points_per_set"]}', style: const TextStyle(fontSize: 18)),
                  Text('Tiempos Fuera: 2 por set', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
