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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.sports_basketball),
        onPressed: () {
          context.push('/tablero');// Acción para iniciar el partido o navegación adicional
        },
      ),
    );
  }
}

class _BasketballSettingsView extends StatefulWidget {
  const _BasketballSettingsView();

  @override
  State<_BasketballSettingsView> createState() =>
      _BasketballSettingsViewState();
}

class _BasketballSettingsViewState extends State<_BasketballSettingsView> {
  // Datos obtenidos de otra configuración
  final String homeTeam = 'Equipo Local'; // Simulación de datos
  final String awayTeam = 'Equipo Visitante'; // Simulación de datos

  String selectedQuarterCount = '4'; // Cantidad de períodos
  bool shotClockEnabled = true; // Tiempo de posesión habilitado
  bool reviewEnabled = false; // Revisiones de jugadas habilitadas

  final quarterOptions = ['4', '2', '6']; // Opciones comunes para períodos

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
          ListTile(
            leading: const Icon(Icons.sports_basketball),
            title: Text('Equipo Local: $homeTeam'),
          ),
          ListTile(
            leading: const Icon(Icons.sports_basketball_outlined),
            title: Text('Equipo Visitante: $awayTeam'),
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'Configuraciones del Partido',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Selección de cantidad de períodos
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
            },
          ),
          const SizedBox(height: 20),
          // Switch para habilitar/deshabilitar el tiempo de posesión
          SwitchListTile(
            title: const Text('Tiempo de Posesión Habilitado'),
            subtitle: const Text('Activar reloj de posesión (24 segundos)'),
            value: shotClockEnabled,
            onChanged: (value) {
              setState(() {
                shotClockEnabled = value;
              });
            },
          ),
          const SizedBox(height: 10),
          // Switch para habilitar/deshabilitar las revisiones de jugadas
          SwitchListTile(
            title: const Text('Habilitar Revisiones de Jugadas'),
            subtitle:
                const Text('Permitir revisiones de jugadas en decisiones clave'),
            value: reviewEnabled,
            onChanged: (value) {
              setState(() {
                reviewEnabled = value;
              });
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
            Text('Equipo Local: $homeTeam'),
            Text('Equipo Visitante: $awayTeam'),
            Text('Cantidad de Períodos: $selectedQuarterCount'),
            Text(
                'Tiempo de Posesión: ${shotClockEnabled ? 'Habilitado' : 'Deshabilitado'}'),
            Text('Revisiones de Jugadas: ${reviewEnabled ? 'Habilitadas' : 'Deshabilitadas'}'),
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
