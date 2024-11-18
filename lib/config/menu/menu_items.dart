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
      title: 'Riverpod Counter ',
      subTitle: 'Introduccion a Riverpod',
      link: '/counter-river',
      icon: Icons.sports_basketball_rounded),
  MenuItem(
      title: 'Configuracion',
      subTitle: 'Configuración general',
      link: '/configuracion',
      icon: Icons.app_settings_alt_rounded),
  MenuItem(
      title: 'Deportes',
      subTitle: 'Seleccionar deporte',
      link: '/deportes',
      icon: Icons.local_play_rounded),
  MenuItem(
      title: 'Introduccion a aplicacion',
      subTitle: 'Pequeño tutotual de la aplicacion',
      link: '/tutorial',
      icon: Icons.temple_buddhist),
  MenuItem(
      title: 'Dispositivos Conectados',
      subTitle: 'Conexion de dispositivos',
      link: '/infinite',
      icon: Icons.masks_rounded),
  MenuItem(
      title: 'Configuracion de tema',
      subTitle: 'Seleccion de color',
      link: '/Theme-changer',
      icon: Icons.color_lens_outlined),
  
];
