import 'package:app_ciel/presentation/widgets/widgets.dart';
import 'package:app_ciel/servicios/data/sports_config_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FutbolScreen extends StatelessWidget {
  static const name = 'futbol_settings_screen';

  const FutbolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Partido de Fútbol'),
      ),
      body: const _FutbolSettingsView(),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Posición
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          FloatingActionButton(
            heroTag: "btnf1", 
            child: const Icon(Icons.settings),
            onPressed: () {
              context.push('/test-soccer-config'); 
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btnf2", 
            child: const Icon(Icons.sports_soccer),
            onPressed: () {
              context.push('/tablero', extra: "soccer"); // parametro de deporte 
            },
          ),
        ],        
      ),
    );
  }
}




  
class _FutbolSettingsView extends StatefulWidget {
  const _FutbolSettingsView();

  @override
  State<_FutbolSettingsView> createState() => _FutbolSettingsViewState();
}

class _FutbolSettingsViewState extends State<_FutbolSettingsView> {
  final SportsConfigService _configService = SportsConfigService();

  String selectedHalfTime = '45'; 
  bool extraTimeEnabled = false; 

  final halfTimeOptions = ['45', '30']; 

  @override
  void initState() {
    super.initState();
    _loadConfig(); 
  }

  Future<void> _loadConfig() async {
    final config = await _configService.getConfig("soccer");
    setState(() {
      selectedHalfTime = halfTimeOptions.contains(config["time_per_half"].toString()) 
          ? config["time_per_half"].toString() 
          : '45'; 
      extraTimeEnabled = config["extra_time_enabled"] ?? false; 
    });
  }

  Future<void> _saveConfig() async {
    final config = {
      "halves": 2, 
      "time_per_half": int.parse(selectedHalfTime),
      "extra_time_enabled": extraTimeEnabled,
    };
    await _configService.saveConfig("soccer", config);
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

          //  EQUIPO LOCAL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _BuildTeamLabel(
                icon: Icons.sports_soccer, 
                label: "Equipo Local",
              ),
              TeamInfoWidget(isLocal: true, isDarkBackground: false), 
            ],
          ),
          const SizedBox(height: 10),

          //  EQUIPO VISITANTE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _BuildTeamLabel(
                icon: Icons.sports_soccer_outlined, 
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
              labelText: 'Duración de los Tiempos (Minutos)',
              border: OutlineInputBorder(),
            ),
            value: selectedHalfTime,
            items: halfTimeOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('$option minutos'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedHalfTime = value!;
              });
              _saveConfig(); 
            },
          ),
          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text('Tiempo Extra Habilitado'),
            subtitle: const Text('Permitir tiempo extra en caso de empate'),
            value: extraTimeEnabled,
            onChanged: (value) {
              setState(() {
                extraTimeEnabled = value;
              });
              _saveConfig(); 
            },
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
            Text('Duración de los Tiempos: $selectedHalfTime minutos'),
            Text('Tiempo Extra: ${extraTimeEnabled ? 'Habilitado' : 'Deshabilitado'}'),
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

