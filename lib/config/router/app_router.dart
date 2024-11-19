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
      path: '/restaurar',
      builder: (context, state) => const RestaurationScreen(),
    ),
     GoRoute(
      path: '/configuracion',
      builder: (context, state) => const ConfiguracionScreen(),
    ),
     GoRoute(
      path: '/deportes',
      builder: (context, state) => const DeportesScreens(),
    ),
                  GoRoute(
                    path: '/basketball',
                    builder: (context, state) => const BasketBallScreen(),
                  ),
                  
                  GoRoute(
                    path: '/futbol',
                    builder: (context, state) => const FutbolScreen(),
                  ),
                  GoRoute(
                    path: '/voleybol',
                    builder: (context, state) => const VoleybolScreen(),
                  ),
  ],
);