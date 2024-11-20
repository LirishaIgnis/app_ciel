import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Información de los slides
class SlidesInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlidesInfo(this.title, this.caption, this.imageUrl);
}

// Lista de slides adaptados al tema del tablero deportivo
final slides = <SlidesInfo>[
  SlidesInfo(
    'Bienvenido a la App de Tablero Deportivo',
    'Gestiona y visualiza tus eventos deportivos con facilidad.',
    'assets/images/sport1.png',
  ),
  SlidesInfo(
    'Crea y organiza partidos',
    'Configura tus partidos, horarios y equipos desde una misma plataforma.',
    'assets/images/sport2.png',
  ),
  SlidesInfo(
    'Visualiza resultados en tiempo real',
    'Mantente al día con resultados actualizados al instante.',
    'assets/images/sport3.png',
  ),
  SlidesInfo(
    'Comparte estadísticas',
    'Exporta y comparte información clave de los juegos.',
    'assets/images/sport4.png',
  ),
];

class AppTutorialScreen extends StatefulWidget {
  static const name = 'tutorial_screen';

  const AppTutorialScreen({super.key});

  @override
  State<AppTutorialScreen> createState() => _AppTutorialScreenState();
}

class _AppTutorialScreenState extends State<AppTutorialScreen> {
  final PageController pageviewController = PageController();
  bool endReached = false;

  @override
  void initState() {
    super.initState();

    pageviewController.addListener(() {
      final page = pageviewController.page ?? 0;
      if (!endReached && page >= (slides.length - 1.5)) {
        setState(() {
          endReached = true;
        });
      }
    });
  }

  @override
  void dispose() {
    pageviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView(
            controller: pageviewController,
            physics: const BouncingScrollPhysics(),
            children: slides
                .map((slideData) => _Slide(
                      title: slideData.title,
                      caption: slideData.caption,
                      imagenUrl: slideData.imageUrl,
                    ))
                .toList(),
          ),
          Positioned(
            right: 20,
            top: 50,
            child: TextButton(
              child: const Text(
                'Omitir',
                style: TextStyle(fontSize: 16),
              ),
              onPressed: () => context.go('/home'), // Ir directamente a home
            ),
          ),
          if (endReached)
            Positioned(
              bottom: 30,
              right: 30,
              child: FadeInRight(
                from: 15,
                delay: const Duration(milliseconds: 300),
                child: FilledButton(
                  onPressed: () => context.go('/home'), // Navegar a home al finalizar
                  child: const Text('Comenzar'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String caption;
  final String imagenUrl;

  const _Slide({
    required this.title,
    required this.caption,
    required this.imagenUrl,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineSmall;
    final captionStyle = Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AssetImage(imagenUrl),
              height: 250,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: titleStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              caption,
              style: captionStyle,
            ),
          ],
        ),
      ),
    );
  }
}
