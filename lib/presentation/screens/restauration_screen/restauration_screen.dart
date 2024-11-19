import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RestaurationScreen extends StatelessWidget {

  const RestaurationScreen({super.key});

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context)=>AlertDialog(
        title: const Text('Desea retomar la partida?'),
        content: const Text('Al retomar esta partida se iniciara desde el momento de pausa'),
        actions: [
          TextButton( onPressed: ()=> context.pop(), child: const Text('Cancelar')),
          FilledButton( onPressed: ()=> context.pop(), child: const Text('Aceptar'))
        ],

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ultimas Partidas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FilledButton.tonal(
                onPressed: () => openDialog(context),
                child: const Text('Paritda final')),
            FilledButton.tonal(
                onPressed: () => openDialog(context),
                child: const Text('Partida 22 de octubre ')),
          ],
        ),
      ),
      );
  }
}