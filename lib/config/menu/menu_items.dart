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
      title: 'Configuracion',
      subTitle: 'Configuración general',
      link: '/configuracion',
      icon: Icons.app_settings_alt_rounded),
  MenuItem(
      title: 'Deportes',
      subTitle: 'Seleccionar deporte',
      link: '/deportes',
      icon: Icons.star_purple500_outlined),
  MenuItem(
      title: 'Informacion de la aplicacion',
      subTitle: 'Licencias y tutorial',
      link: '/tutorial',
      icon: Icons.adb_rounded),
  MenuItem(
      title: 'Dispositivos Conectados',
      subTitle: 'Conexion de dispositivos',
      link: '/infinite',
      icon: Icons.connect_without_contact_sharp),  
];
