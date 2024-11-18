import 'package:app_ciel/presentation/screens/configuracion/configuracion_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:app_ciel/presentation/screens/screens.dart';

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: '/', // primera ruta 
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
     GoRoute(
      path: '/configuracion',
      builder: (context, state) => const ConfiguracionScreen(),
    ),
     GoRoute(
      path: '/deportes',
      builder: (context, state) => const DeportesScreens(),
    ),
  ],
);