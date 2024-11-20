import 'package:flutter/material.dart';

class MenuItem {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const MenuItem(
      {required this.title,
      required this.subTitle,
      required this.link,
      required this.icon});
}

const appMenuItems = <MenuItem>[
  MenuItem(
      title: 'Restaurar ultimo partido',
      subTitle: 'Retoma el ultimo partido guardado',
      link: '/restaurar',
      icon: Icons.sports_outlined),
  MenuItem(
      title: 'Configuración ',
      subTitle: ' Configura aqui la informacion de los equipos ',
      link: '/configuracion',
      icon: Icons.settings_suggest_rounded),
  MenuItem(
      title: 'Deportes',
      subTitle: 'Seleccionar deporte',
      link: '/deportes',
      icon: Icons.star_purple500_outlined),
  MenuItem(
      title: 'Informacion de la aplicacion',
      subTitle: 'Licencias y tutorial',
      link: '/infoscreen',
      icon: Icons.adb_rounded),
  MenuItem(
      title: 'Dispositivos Conectados',
      subTitle: 'Conexion de dispositivos',
      link: '/conexion',
      icon: Icons.connect_without_contact_sharp),  
];
