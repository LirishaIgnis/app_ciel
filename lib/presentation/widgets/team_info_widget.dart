import 'package:flutter/material.dart';
import 'package:app_ciel/models/team_model.dart';
import 'package:app_ciel/servicios/data/hive_service.dart';

class TeamInfoWidget extends StatefulWidget {
  final bool isLocal; // Define si es el equipo local o visitante
  final bool isDarkBackground; // Nuevo parámetro para manejar el color del texto

  const TeamInfoWidget({Key? key, required this.isLocal, required this.isDarkBackground}) : super(key: key);

  @override
  _TeamInfoWidgetState createState() => _TeamInfoWidgetState();
}

class _TeamInfoWidgetState extends State<TeamInfoWidget> {
  String teamName = "Cargando...";
  String acronym = "???";
  Color primaryColor = Colors.grey;
  Color secondaryColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    _loadTeamData();
  }

  void _loadTeamData() {
    final Team? team = widget.isLocal ? HiveService.getTeam1() : HiveService.getTeam2();
    
    if (team != null) {
      setState(() {
        teamName = team.name;
        acronym = team.acronym;
        primaryColor = team.getPrimaryColor();
        secondaryColor = team.getSecondaryColor();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // **📌 Ajuste de color del texto dependiendo del fondo**
    Color textColor = widget.isDarkBackground ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(teamName, style: TextStyle(fontSize: 25, color: textColor, fontWeight: FontWeight.bold)),
            Text(acronym, style: TextStyle(fontSize: 16, color: textColor)),
          ],
        ),
        SizedBox(width: 10),
        Container(width: 20, height: 20, color: primaryColor),
        SizedBox(width: 5),
        Container(width: 20, height: 20, color: secondaryColor),
      ],
    );
  }
}


