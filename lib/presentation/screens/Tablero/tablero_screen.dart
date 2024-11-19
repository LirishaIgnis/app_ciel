import 'package:flutter/material.dart';

class TableroScreen extends StatefulWidget {
  const TableroScreen({super.key});

  @override
  State<TableroScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<TableroScreen> {
  int clickCounter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Tablero deportivo borrador'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () {
                setState(() {
                  clickCounter = 0;
                });
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('$clickCounter',
                  style: const TextStyle(
                      fontSize: 160, fontWeight: FontWeight.w100)),
              Text('Punto${clickCounter == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 25))
            ],
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _CustomBotton(
              icon: Icons.plus_one,
              heroTag: 'btn1', // heroTag único
              onPressed: () {
                clickCounter++;
                setState(() {});
              },
            ),
            const SizedBox(width: 10),
           _CustomBotton(
              icon: Icons.exposure_plus_2_outlined,
              heroTag: 'btn2', // heroTag único
              onPressed: () {
                clickCounter = clickCounter + 3;
                setState(() {});
              },
            ),
            const SizedBox(width: 10),
            _CustomBotton(
              icon: Icons.exposure_plus_2_rounded,
              heroTag: 'btn3', // heroTag único
              onPressed: () {
                clickCounter = clickCounter + 2;
                setState(() {});
              },
            ),
            const SizedBox(width: 10),
             _CustomBotton(
              icon: Icons.exposure_minus_1,
              heroTag: 'btn4', // heroTag único
              onPressed: () {
                if (clickCounter == 0) return;
                clickCounter--;
                setState(() {});
              },
            ),
            
          ],
        ));
  }
}

class _CustomBotton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String heroTag; // Añadimos heroTag como parámetro

  const _CustomBotton({
    required this.icon,
    required this.heroTag, // Marcamos heroTag como requerido
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: heroTag, // Asignamos el heroTag único
      shape: const StadiumBorder(),
      enableFeedback: true,
      elevation: 8,
      backgroundColor: Colors.lightBlueAccent,
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}