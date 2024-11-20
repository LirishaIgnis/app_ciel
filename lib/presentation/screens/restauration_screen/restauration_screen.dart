import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurationScreen extends StatelessWidget {
   RestaurationScreen({super.key});

  // Lista dinámica de partidas
  final List<String> partidas = [
    'Partida final',
    'Partida 22 de octubre',
    'Partida 10 de noviembre',
    'Partida rápida de entrenamiento',
    'Partida del torneo local'
  ];

  void openDialog(BuildContext context, String partida) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '¿Desea retomar "$partida"?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        content: const Text(
          'Al retomar esta partida, se reanudará desde el último punto guardado.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              // Aquí podrías añadir la lógica de restauración
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Restaurando "$partida"...')),
              );
            },
            child: const Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Últimas Partidas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selecciona una partida para restaurar:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: partidas.length,
                itemBuilder: (context, index) {
                  final partida = partidas[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 3,
                    child: ListTile(
                      title: Text(partida),
                      trailing: const Icon(Icons.restore),
                      onTap: () => openDialog(context, partida),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
