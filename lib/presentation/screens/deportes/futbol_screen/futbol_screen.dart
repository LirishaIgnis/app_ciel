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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.sports_soccer),
        onPressed: () {
          context.push('/tablero');
          // Acción para iniciar el partido o navegación adicional
        },
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
  // Datos obtenidos de otra configuración
  final String homeTeam = 'Equipo Local'; // Simulación de datos
  final String awayTeam = 'Equipo Visitante'; // Simulación de datos

  String selectedHalfTime = '45'; // Duración de los tiempos
  bool extraTimeEnabled = false; // Tiempo extra habilitado
  bool penaltyShootoutEnabled = false; // Penales habilitados
  bool varEnabled = false; // VAR habilitado

  final halfTimeOptions = ['45', '30']; // Opciones comunes para duraciones

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
            leading: const Icon(Icons.sports_soccer),
            title: Text('Equipo Local: $homeTeam'),
          ),
          ListTile(
            leading: const Icon(Icons.support),
            title: Text('Equipo Visitante: $awayTeam'),
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'Configuraciones del Partido',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Selección de duración de los tiempos
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
            },
          ),
          const SizedBox(height: 20),
          // Switch para habilitar/deshabilitar el tiempo extra
          SwitchListTile(
            title: const Text('Tiempo Extra Habilitado'),
            subtitle: const Text('Permitir tiempo extra en caso de empate'),
            value: extraTimeEnabled,
            onChanged: (value) {
              setState(() {
                extraTimeEnabled = value;
              });
            },
          ),
          const SizedBox(height: 10),
          // Switch para habilitar/deshabilitar los penales
          SwitchListTile(
            title: const Text('Penales Habilitados'),
            subtitle: const Text('Permitir penales en caso de empate tras tiempo extra'),
            value: penaltyShootoutEnabled,
            onChanged: (value) {
              setState(() {
                penaltyShootoutEnabled = value;
              });
            },
          ),
          const SizedBox(height: 10),
          // Switch para habilitar/deshabilitar el VAR
          SwitchListTile(
            title: const Text('VAR Habilitado'),
            subtitle: const Text('Permitir el uso del VAR (Revisión de jugadas)'),
            value: varEnabled,
            onChanged: (value) {
              setState(() {
                varEnabled = value;
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
            Text('Duración de los Tiempos: $selectedHalfTime minutos'),
            Text(
                'Tiempo Extra: ${extraTimeEnabled ? 'Habilitado' : 'Deshabilitado'}'),
            Text(
                'Penales: ${penaltyShootoutEnabled ? 'Habilitados' : 'Deshabilitados'}'),
            Text('VAR: ${varEnabled ? 'Habilitado' : 'Deshabilitado'}'),
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
