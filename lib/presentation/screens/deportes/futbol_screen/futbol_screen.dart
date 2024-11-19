import 'package:app_ciel/presentation/screens/Tablero/tablero_screen.dart';
import 'package:flutter/material.dart';

class FutbolScreen extends StatelessWidget {
  static const name = 'ui_controls_screen';

  const FutbolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuracion Futbol'),
      ),
      body: const _UiControlsView(),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.sports_soccer),
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

enum Transportations { car, plane, boat, submarine }

class _UiControlsViewState extends State<_UiControlsView> {
  bool isDeveloper = true;
  Transportations selectedTranspotation = Transportations.car;
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
          subtitle: Text('$selectedTranspotation'),
          children: [
            RadioListTile(
              title: const Text('By Car'),
              subtitle: const Text('Viajar en carro'),
              value: Transportations.car,
              groupValue: selectedTranspotation,
              onChanged: (value) => setState(() {
                selectedTranspotation = Transportations.car;
              }),
            ),
            RadioListTile(
              title: const Text('By Boat'),
              subtitle: const Text('Viajar en Bote'),
              value: Transportations.boat,
              groupValue: selectedTranspotation,
              onChanged: (value) => setState(() {
                selectedTranspotation = Transportations.boat;
              }),
            ),
            RadioListTile(
              title: const Text('By Plane'),
              subtitle: const Text('Viajar en Avion'),
              value: Transportations.plane,
              groupValue: selectedTranspotation,
              onChanged: (value) => setState(() {
                selectedTranspotation = Transportations.plane;
              }),
            ),
            RadioListTile(
              title: const Text('By Submarine'),
              subtitle: const Text('Viajar en Submarino'),
              value: Transportations.submarine,
              groupValue: selectedTranspotation,
              onChanged: (value) => setState(() {
                selectedTranspotation = Transportations.submarine;
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