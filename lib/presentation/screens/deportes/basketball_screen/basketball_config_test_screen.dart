import 'package:app_ciel/servicios/data/sports_config_service.dart';
import 'package:flutter/material.dart';

class BasketballConfigTestScreen extends StatefulWidget {
  const BasketballConfigTestScreen({super.key});

  @override
  State<BasketballConfigTestScreen> createState() => _BasketballConfigTestScreenState();
}

class _BasketballConfigTestScreenState extends State<BasketballConfigTestScreen> {
  final SportsConfigService _configService = SportsConfigService();
  Map<String, dynamic>? _config;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final config = await _configService.getConfig("basketball"); 
    setState(() {
      _config = config;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración de Baloncesto')),
      body: _config == null
          ? const Center(child: CircularProgressIndicator()) // Cargando datos
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Cantidad de Períodos: ${_config!["periods"]}', style: const TextStyle(fontSize: 18)),
                  Text('Duración de Período: ${_config!["time_per_period"]} minutos', style: const TextStyle(fontSize: 18)),
                  Text('Reloj de Posesión: ${_config!["shotClockEnabled"] ? "Habilitado (24s)" : "Deshabilitado"}', style: const TextStyle(fontSize: 18)),
                  Text('Tiempos Fuera Permitidos: 5 por equipo (1 minuto c/u)', style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
    );
  }
}
