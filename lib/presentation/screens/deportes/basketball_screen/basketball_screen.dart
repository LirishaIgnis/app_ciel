import 'package:app_ciel/presentation/widgets/widgets.dart';
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
          context.push('/tablero'); // Acción para iniciar el partido o navegación adicional
        },
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
  String selectedQuarterCount = '4'; 
  bool shotClockEnabled = true; 
  bool reviewEnabled = false; 

  final quarterOptions = ['4', '2', '6']; 

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
                icon: Icons.sports_basketball, 
                label: "Equipo Local",
              ),
              TeamInfoWidget(isLocal: true, isDarkBackground: false), // Fondo claro
            ],
          ),
          const SizedBox(height: 10),

          // ✅ EQUIPO VISITANTE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _BuildTeamLabel(
                icon: Icons.sports_basketball_outlined, 
                label: "Equipo Visitante",
              ),
              TeamInfoWidget(isLocal: false, isDarkBackground: false), // Fondo claro
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
            },
          ),
          const SizedBox(height: 10),

          SwitchListTile(
            title: const Text('Habilitar Revisiones de Jugadas'),
            subtitle: const Text('Permitir revisiones de jugadas en decisiones clave'),
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
            Text('Cantidad de Períodos: $selectedQuarterCount'),
            Text('Tiempo de Posesión: ${shotClockEnabled ? 'Habilitado' : 'Deshabilitado'}'),
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
