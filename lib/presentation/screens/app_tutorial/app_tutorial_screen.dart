import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppInfoScreen extends StatelessWidget {
  static const name = 'app_info_screen';

  const AppInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Información de la App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'App de Tablero Deportivo',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Ciel Ingeniería',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'Versión 1.0',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Divider(height: 32),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text('Tutorial de la App'),
              subtitle: const Text('Aprende cómo usar todas las funciones'),
              onTap: () {
                context.push('/tutorial'); // Navegar al tutorial
              },
            ),
            ListTile(
              leading: const Icon(Icons.book),
              title: const Text('Licencias'),
              subtitle: const Text('Consulta las licencias de esta aplicación'),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Tablero Deportivo',
                  applicationVersion: '1.0',
                  applicationLegalese: '© 2024 Ciel Ingeniería',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
