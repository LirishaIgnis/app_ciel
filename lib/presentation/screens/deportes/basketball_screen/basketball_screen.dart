import 'package:app_ciel/presentation/widgets/widgets.dart';
import 'package:app_ciel/servicios/data/sports_config_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BasketBallScreen extends StatelessWidget {
  static const name = 'basketball_settings_screen';

  const BasketBallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Partido de Basketball'),
      ),
      body: const _BasketballSettingsView(),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Posición
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          FloatingActionButton(
            heroTag: "btn1", 
            child: const Icon(Icons.settings),
            onPressed: () {
              context.push('/test-basketball-config'); 
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "btn2", 
            child: const Icon(Icons.sports_basketball),
            onPressed: () {
              context.push('/tablero', extra: "basketball"); // parametro de deporte 
            },
          ),
        ],        
      ),
    );
  }
}

class _BasketballSettingsView extends StatefulWidget {
  const _BasketballSettingsView();

  @override
  State<_BasketballSettingsView> createState() => _BasketballSettingsViewState();
}

class _BasketballSettingsViewState extends State<_BasketballSettingsView> {
  final SportsConfigService _configService = SportsConfigService();

  String selectedQuarterCount = '4'; 
  String selectedPeriodDuration = '10'; 
  bool shotClockEnabled = true;  

  final quarterOptions = ['4', '2', '6']; 
  final periodDurationOptions = ['10', '15', '20']; 

  @override
  void initState() {
    super.initState();
    _loadConfig(); 
  }

  Future<void> _loadConfig() async {
    final config = await _configService.getConfig("basketball");
    setState(() {
      selectedQuarterCount = config["periods"].toString();
      selectedPeriodDuration = periodDurationOptions.contains(config["time_per_period"].toString()) 
          ? config["time_per_period"].toString() 
          : '10'; 
      shotClockEnabled = config["shotClockEnabled"];
    });
  }

  Future<void> _saveConfig() async {
    final config = {
      "periods": int.parse(selectedQuarterCount),
      "time_per_period": int.parse(selectedPeriodDuration),
      "shotClockEnabled": shotClockEnabled,
    };
    await _configService.saveConfig("basketball", config);
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _BuildTeamLabel(
                icon: Icons.sports_basketball, 
                label: "Equipo Local",
              ),
              TeamInfoWidget(isLocal: true, isDarkBackground: false), 
            ],
          ),
          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _BuildTeamLabel(
                icon: Icons.sports_basketball_outlined, 
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
              labelText: 'Cantidad de Períodos',
              border: OutlineInputBorder(),
            ),
            value: selectedQuarterCount,
            items: quarterOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('$option períodos'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedQuarterCount = value!;
              });
              _saveConfig(); 
            },
          ),
          const SizedBox(height: 20),

          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Duración de cada Período (minutos)',
              border: OutlineInputBorder(),
            ),
            value: selectedPeriodDuration,
            items: periodDurationOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('$option minutos'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedPeriodDuration = value!;
              });
              _saveConfig(); 
            },
          ),
          const SizedBox(height: 20),

          SwitchListTile(
            title: const Text('Tiempo de Posesión Habilitado'),
            subtitle: const Text('Activar reloj de posesión (24 segundos)'),
            value: shotClockEnabled,
            onChanged: (value) {
              setState(() {
                shotClockEnabled = value;
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
            Text('Cantidad de Períodos: $selectedQuarterCount'),
            Text('Duración del Período: $selectedPeriodDuration minutos'),
            Text('Tiempo de Posesión: ${shotClockEnabled ? 'Habilitado' : 'Deshabilitado'}'),
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

/// WIDGET PARA MOSTRAR TEXTO + ÍCONO DEL EQUIPO (IZQUIERDA)
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
