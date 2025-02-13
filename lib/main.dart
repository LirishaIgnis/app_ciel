import 'package:flutter/material.dart';
import 'package:app_ciel/config/router/app_router.dart';
import 'package:app_ciel/config/theme/app_theme.dart';
import 'package:app_ciel/presentation/providers/providers.dart'; // Importa tu archivo de Providers

void main() {
  runApp(
    appProviders(
      child: const MainApp(), // envuelve tu MainApp con appProviders
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).getTheme(),
    );
  }
}

