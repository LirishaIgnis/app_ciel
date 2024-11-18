import 'package:flutter/material.dart';
import 'package:app_ciel/config/router/app_router.dart';
import 'package:app_ciel/config/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {

const MainApp ({super.key});

@override
  Widget build(BuildContext context) {
   return  MaterialApp.router(
    routerConfig: appRouter,
    debugShowCheckedModeBanner: false,
    theme: AppTheme(selectedColor:0 ).getTheme(),
    
    
    //routes: {  Especificacion para navegacion basica entre pantallas. Aqui se crean las rutas para llamarlas en el home_screen
      
      //'/configuración' :(context)=>const ConfiguracionScreen(),
      //'/deportes':(context)=>const DeportesScreen(),    
    //},  
    
     
   );
  }
}