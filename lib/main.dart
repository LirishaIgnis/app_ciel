import 'package:app_ciel/models/team_model.dart';
import 'package:flutter/material.dart';
import 'package:app_ciel/config/router/app_router.dart';
import 'package:app_ciel/config/theme/app_theme.dart';
import 'package:app_ciel/presentation/providers/providers.dart'; // Importa tu archivo de Providers
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app_ciel/servicios/data/hive_service.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); 
  
  // ✅ Registrar el adaptador de Hive
  Hive.registerAdapter(TeamAdapter());

  // ✅ Inicializar Hive Service
  await HiveService.init();
// Inicializa Hive antes de ejecutar la app

  runApp(
    appProviders(
      child: const MainApp(), // Envuelve tu MainApp con appProviders
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


