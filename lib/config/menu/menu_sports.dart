import 'package:flutter/material.dart';

class SportItems {
  final String title;
  final String subTitle;
  final String link;
  final IconData icon;

  const SportItems(
      {required this.title,
      required this.subTitle,
      required this.link,
      required this.icon});
}

const appSportItems = <SportItems>[
  SportItems(
      title: 'Basketball',
      subTitle: 'Configuracion de partido',
      link: '/counter-river',
      icon: Icons.sports_basketball_rounded),
  SportItems(
      title: 'Futbol',
      subTitle: 'Configuracion de patido',
      link: '/counter-river',
      icon: Icons.sports_soccer_outlined),
  SportItems(
      title: 'Voleybol',
      subTitle: 'Configuracion de patido',
      link: '/counter-river',
      icon: Icons.sports_volleyball_rounded),
  
];
