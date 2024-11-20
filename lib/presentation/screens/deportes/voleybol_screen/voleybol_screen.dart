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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.sports_volleyball),
        onPressed: () {
          context.push('/tablero');
          // Acción para iniciar el partido o navegación adicional
        },
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
  // Datos obtenidos de otra configuración
  final String homeTeam = 'Equipo Local'; // Simulación de datos
  final String awayTeam = 'Equipo Visitante'; // Simulación de datos

  int numberOfSets = 3; // Número de sets
  int pointsPerSet = 25; // Puntos por set
  bool timeOutEnabled = true; // Habilitar tiempo muerto
  String serveType = 'Rotación'; // Tipo de servicio (Rotación o el tipo de saque)

  final setOptions = [3, 5]; // Opciones para la cantidad de sets
  final pointOptions = [15, 20, 25]; // Opciones para los puntos por set
  final serveOptions = ['Rotación', 'Saque de pie']; // Opciones de tipo de saque

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
            leading: const Icon(Icons.sports_volleyball),
            title: Text('Equipo Local: $homeTeam'),
          ),
          ListTile(
            leading: const Icon(Icons.sports_volleyball_outlined),
            title: Text('Equipo Visitante: $awayTeam'),
          ),
          const Divider(),
          const SizedBox(height: 10),
          const Text(
            'Configuraciones del Partido',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Número de sets
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Número de Sets',
              border: OutlineInputBorder(),
            ),
            value: numberOfSets,
            items: setOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('$option Sets'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                numberOfSets = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          // Puntos por set
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Puntos por Set',
              border: OutlineInputBorder(),
            ),
            value: pointsPerSet,
            items: pointOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text('$option Puntos'),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                pointsPerSet = value!;
              });
            },
          ),
          const SizedBox(height: 20),
          // Switch para habilitar/deshabilitar el tiempo muerto
          SwitchListTile(
            title: const Text('Tiempo Muerto Habilitado'),
            subtitle: const Text('Permitir tiempos muertos durante el partido'),
            value: timeOutEnabled,
            onChanged: (value) {
              setState(() {
                timeOutEnabled = value;
              });
            },
          ),
          const SizedBox(height: 20),
          // Selección de tipo de saque
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Tipo de Saque',
              border: OutlineInputBorder(),
            ),
            value: serveType,
            items: serveOptions
                .map((option) => DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                serveType = value!;
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
            Text('Número de Sets: $numberOfSets'),
            Text('Puntos por Set: $pointsPerSet'),
            Text('Tiempo Muerto: ${timeOutEnabled ? 'Habilitado' : 'Deshabilitado'}'),
            Text('Tipo de Saque: $serveType'),
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
