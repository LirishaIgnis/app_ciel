import 'package:app_ciel/presentation/screens/Tablero/tablero_screen.dart';
import 'package:flutter/material.dart';

class BasketBallScreen extends StatelessWidget {
  static const name = 'ui_controls_screen';

  const BasketBallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion Basketball'),
      ),
      body: const _UiControlsView(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.sports_basketball_outlined),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
              builder: (context) => TableroScreen(),
              ),
            );
          }),
    );
  }
}

class _UiControlsView extends StatefulWidget {
  const _UiControlsView();

  @override
  State<_UiControlsView> createState() => _UiControlsViewState();
}

enum Tiempo { car, plane, boat, submarine }

class _UiControlsViewState extends State<_UiControlsView> {
  bool isDeveloper = true;
  Tiempo selectedTiempo = Tiempo.car;
  bool wantsBreakfast = false;
  bool wantsLunch = false;
  bool wantsDinner = false;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const ClampingScrollPhysics(),
      children: [
        SwitchListTile(
          title: const Text('Developer Mode'),
          subtitle: const Text('Controles adicionales'),
          value: isDeveloper,
          onChanged: (value) => setState(() {
            isDeveloper = !isDeveloper;
          }),
        ),
        ExpansionTile(
          title: const Text('Vehiculo de transporte'),
          subtitle: Text('$selectedTiempo'),
          children: [
            RadioListTile(
              title: const Text('By Car'),
              subtitle: const Text('Viajar en carro'),
              value: Tiempo.car,
              groupValue: selectedTiempo,
              onChanged: (value) => setState(() {
                selectedTiempo = Tiempo.car;
              }),
            ),
            RadioListTile(
              title: const Text('By Boat'),
              subtitle: const Text('Viajar en Bote'),
              value: Tiempo.boat,
              groupValue: selectedTiempo,
              onChanged: (value) => setState(() {
                selectedTiempo = Tiempo.boat;
              }),
            ),
            RadioListTile(
              title: const Text('By Plane'),
              subtitle: const Text('Viajar en Avion'),
              value: Tiempo.plane,
              groupValue: selectedTiempo,
              onChanged: (value) => setState(() {
                selectedTiempo = Tiempo.plane;
              }),
            ),
            RadioListTile(
              title: const Text('By Submarine'),
              subtitle: const Text('Viajar en Submarino'),
              value: Tiempo.submarine,
              groupValue: selectedTiempo,
              onChanged: (value) => setState(() {
                selectedTiempo = Tiempo.submarine;
              }),
            ),
          ],
        ),
        CheckboxListTile(
          title: const Text('Quiere desayuno?'),
          value: wantsBreakfast,
          onChanged: (value) => setState(() {
            wantsBreakfast = !wantsBreakfast;
          }),
        ),
        CheckboxListTile(
          title: const Text('Quiere Almuerzo?'),
          value: wantsLunch,
          onChanged: (value) => setState(() {
            wantsLunch = !wantsLunch;
          }),
        ),
        CheckboxListTile(
          title: const Text('Quiere Cena?'),
          value: wantsDinner,
          onChanged: (value) => setState(() {
            wantsDinner = !wantsDinner;
          }),
        ),
      ],
    );
  }
}
