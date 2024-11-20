import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  const ConfiguracionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de Equipos'),
      ),
      body: const TeamConfigForm(),
    );
  }
}

class TeamConfigForm extends StatefulWidget {
  const TeamConfigForm({super.key});

  @override
  State<TeamConfigForm> createState() => _TeamConfigFormState();
}

class _TeamConfigFormState extends State<TeamConfigForm> {
  final _formKey = GlobalKey<FormState>();
  final _team1NameController = TextEditingController();
  final _team1AcronymController = TextEditingController();
  Color? _team1PrimaryColor;
  Color? _team1SecondaryColor;

  final _team2NameController = TextEditingController();
  final _team2AcronymController = TextEditingController();
  Color? _team2PrimaryColor;
  Color? _team2SecondaryColor;

  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.black,
    Colors.white,
    Colors.purple,
    Colors.orange,
  ];

  final List<String> _colorNames = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Black',
    'White',
    'Purple',
    'Orange',
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_team1PrimaryColor == null ||
          _team1SecondaryColor == null ||
          _team2PrimaryColor == null ||
          _team2SecondaryColor == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecciona todos los colores')),
        );
        return;
      }

      if (_team1PrimaryColor == _team1SecondaryColor ||
          _team2PrimaryColor == _team2SecondaryColor) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Los colores primario y secundario deben ser diferentes')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamSummaryScreen(
            team1: Team(
              name: _team1NameController.text,
              acronym: _team1AcronymController.text,
              primaryColor: _team1PrimaryColor!,
              secondaryColor: _team1SecondaryColor!,
            ),
            team2: Team(
              name: _team2NameController.text,
              acronym: _team2AcronymController.text,
              primaryColor: _team2PrimaryColor!,
              secondaryColor: _team2SecondaryColor!,
            ),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _team1NameController.dispose();
    _team1AcronymController.dispose();
    _team2NameController.dispose();
    _team2AcronymController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Equipo 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTeamForm(
              nameController: _team1NameController,
              acronymController: _team1AcronymController,
              primaryColor: _team1PrimaryColor,
              secondaryColor: _team1SecondaryColor,
              onPrimaryColorChanged: (value) {
                setState(() {
                  _team1PrimaryColor = value;
                });
              },
              onSecondaryColorChanged: (value) {
                setState(() {
                  _team1SecondaryColor = value;
                });
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Equipo 2',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildTeamForm(
              nameController: _team2NameController,
              acronymController: _team2AcronymController,
              primaryColor: _team2PrimaryColor,
              secondaryColor: _team2SecondaryColor,
              onPrimaryColorChanged: (value) {
                setState(() {
                  _team2PrimaryColor = value;
                });
              },
              onSecondaryColorChanged: (value) {
                setState(() {
                  _team2SecondaryColor = value;
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Enviar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamForm({
    required TextEditingController nameController,
    required TextEditingController acronymController,
    required Color? primaryColor,
    required Color? secondaryColor,
    required ValueChanged<Color?> onPrimaryColorChanged,
    required ValueChanged<Color?> onSecondaryColorChanged,
  }) {
    return Column(
      children: [
        TextFormField(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Equipo',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el nombre del equipo';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: acronymController,
          decoration: const InputDecoration(
            labelText: 'Acrónimo (3 caracteres)',
            border: OutlineInputBorder(),
          ),
          maxLength: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingresa el acrónimo';
            }
            if (value.length != 3) {
              return 'El acrónimo debe tener exactamente 3 caracteres';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<Color>(
          decoration: const InputDecoration(
            labelText: 'Color Primario',
            border: OutlineInputBorder(),
          ),
          value: primaryColor,
          items: _colors
              .asMap()
              .entries
              .map((entry) => DropdownMenuItem(
                    value: entry.value,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: entry.value,
                        ),
                        const SizedBox(width: 10),
                        Text(_colorNames[entry.key]),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: onPrimaryColorChanged,
          validator: (value) {
            if (value == null) {
              return 'Por favor selecciona un color primario';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<Color>(
          decoration: const InputDecoration(
            labelText: 'Color Secundario',
            border: OutlineInputBorder(),
          ),
          value: secondaryColor,
          items: _colors
              .asMap()
              .entries
              .map((entry) => DropdownMenuItem(
                    value: entry.value,
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          color: entry.value,
                        ),
                        const SizedBox(width: 10),
                        Text(_colorNames[entry.key]),
                      ],
                    ),
                  ))
              .toList(),
          onChanged: onSecondaryColorChanged,
          validator: (value) {
            if (value == null) {
              return 'Por favor selecciona un color secundario';
            }
            return null;
          },
        ),
      ],
    );
  }
}

class TeamSummaryScreen extends StatelessWidget {
  final Team team1;
  final Team team2;

  const TeamSummaryScreen({
    super.key,
    required this.team1,
    required this.team2,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen de Equipos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Equipo 1',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildTeamSummary(team1),
            const SizedBox(height: 20),
            const Text(
              'Equipo 2',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            _buildTeamSummary(team2),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSummary(Team team) {
    return Column(
      children: [
        Text('Nombre: ${team.name}'),
        Text('Acrónimo: ${team.acronym}'),
        Row(
          children: [
            const Text('Colores: '),
            Container(
              width: 50,
              height: 50,
              color: team.primaryColor,
            ),
            const SizedBox(width: 5),
            Container(
              width: 50,
              height: 50,
              color: team.secondaryColor,
            ),
          ],
        ),
      ],
    );
  }
}

class Team {
  final String name;
  final String acronym;
  final Color primaryColor;
  final Color secondaryColor;

  Team({
    required this.name,
    required this.acronym,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
