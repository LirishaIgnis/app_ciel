import 'package:app_ciel/presentation/screens/app_tutorial/tutorial_screen.dart';
import 'package:app_ciel/presentation/screens/deportes/futbol_screen/soccer_config_test_screen.dart';
import 'package:app_ciel/presentation/screens/deportes/voleybol_screen/voleybol_config_test_screen.dart';
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
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
     GoRoute(
      path: '/restaurar',
      builder: (context, state) =>  RestaurationScreen(),
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
                                  path: '/test-basketball-config',
                                  builder: (context, state) => const BasketballConfigTestScreen(),
                          ),
                  
                  GoRoute(
                    path: '/futbol',
                    builder: (context, state) => const FutbolScreen(),
                  ),
                          GoRoute(
                                  path: '/test-soccer-config',
                                  builder: (context, state) => const SoccerConfigTestScreen(),
                          ),
                  GoRoute(
                    path: '/voleybol',
                    builder: (context, state) => const VoleybolScreen(),
                  ),
                        GoRoute(
                                  path: '/test-voleybol-config',
                                  builder: (context, state) => const VolleyballConfigTestScreen(),
                          ),     

                
                              GoRoute(
                                path: '/tablero',
                                builder: (context, state) => GameView(),
                              ),
    GoRoute(
      path: '/conexion',
      builder: (context, state) => const ConexionScreen(),
    ),
    GoRoute(
      path: '/infoscreen',
      builder: (context, state) => const AppInfoScreen(),
    ),
                  GoRoute(
                    path: '/tutorial',
                    builder: (context, state) => const AppTutorialScreen(),
                  ),
     GoRoute(
      path: '/confgeneral',
      builder: (context, state) => const GeneralSettingsScreen(),
    ),
    
  ],
);