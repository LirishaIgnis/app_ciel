import 'package:app_ciel/presentation/widgets/widgets.dart';
import 'package:app_ciel/servicios/data/sports_config_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class VoleybolScreen extends StatelessWidget {
  static const name = 'voleybol_settings_screen';

  const VoleybolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Partido de Vóleybol'),
      ),
      body: const _VoleybolSettingsView(),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Posición
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          FloatingActionButton(
            heroTag: "btnv1", 
            child: const Icon(Icons.settings),
            onPressed: () {
              context.push('/test-voleybol-config'); 
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btnv2", 
            child: const Icon(Icons.sports_volleyball),
            onPressed: () {
              context.push('/tablero'); 
            },
          ),
        ],        
      ),
    );
  }
}


class _VoleybolSettingsView extends StatefulWidget {
  const _VoleybolSettingsView();

  @override
  State<_VoleybolSettingsView> createState() => _VoleybolSettingsViewState();
}

class _VoleybolSettingsViewState extends State<_VoleybolSettingsView> {
  final SportsConfigService _configService = SportsConfigService();

  String selectedSetCount = '5'; 
  String selectedPointsPerSet = '25'; 
  int minimumDifference = 2; // ✅ Ahora se carga desde Hive

  final List<String> setOptions = ['3', '5']; 
  final List<String> pointOptions = ['15', '20', '25']; 

  @override
  void initState() {
    super.initState();
    _loadConfig(); 
  }

  Future<void> _loadConfig() async {
    final config = await _configService.getConfig("volleyball");
    setState(() {
      selectedSetCount = setOptions.contains(config["sets"].toString()) 
          ? config["sets"].toString() 
          : '5'; 
      selectedPointsPerSet = pointOptions.contains(config["points_per_set"].toString()) 
          ? config["points_per_set"].toString() 
          : '25';
      minimumDifference = config["minimum_difference"] ?? 2; // ✅ Se carga desde Hive
    });
  }

  Future<void> _saveConfig() async {
    final config = {
      "sets": int.parse(selectedSetCount),
      "points_per_set": int.parse(selectedPointsPerSet),
      "minimum_difference": minimumDifference,
    };
    await _configService.saveConfig("volleyball", config);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const Text(
            'Equipos Participantes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // ✅ EQUIPO LOCAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _BuildTeamLabel(
                icon: Icons.sports_volleyball, 
                label: "Equipo Local",
              ),
              TeamInfoWidget(isLocal: true, isDarkBackground: false), 
            ],
          ),
          const SizedBox(height: 10),

          // ✅ EQUIPO VISITANTE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _BuildTeamLabel(
                icon: Icons.sports_volleyball_outlined, 
                label: "Equipo Visitante",
              ),
              TeamInfoWidget(isLocal: false, isDarkBackground: false), 
            ],
          ),

          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'Configuraciones del Partido',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Número de Sets',
              border: OutlineInputBorder(),
            ),
            value: selectedSetCount,
            items: setOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('$option Sets'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedSetCount = value!;
              });
              _saveConfig(); 
            },
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Puntos por Set',
              border: OutlineInputBorder(),
            ),
            value: selectedPointsPerSet,
            items: pointOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('$option Puntos'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedPointsPerSet = value!;
              });
              _saveConfig(); 
            },
          ),
          const SizedBox(height: 20),

          // ✅ Se muestra la diferencia mínima de puntos
          Text(
            'Diferencia mínima de puntos: $minimumDifference',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),

          // ✅ Se mantiene el número de tiempos fuera por set
          const Text(
            'Tiempos Fuera: 2 por set',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 30),

          Center(
            child: ElevatedButton(
              onPressed: _showSummary,
              child: const Text('Guardar y Mostrar Configuración'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSummary() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Resumen del Partido'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Número de Sets: $selectedSetCount'),
            Text('Puntos por Set: $selectedPointsPerSet'),
            Text('Diferencia mínima de puntos: $minimumDifference'),
            Text('Tiempos Fuera: 2 por set'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

/// ✅ WIDGET PARA MOSTRAR TEXTO + ÍCONO DEL EQUIPO (IZQUIERDA)
class _BuildTeamLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _BuildTeamLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
