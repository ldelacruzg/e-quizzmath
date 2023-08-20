import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SlideInfo {
  final String title;
  final String caption;
  final String imageUrl;

  SlideInfo(this.title, this.caption, this.imageUrl);
}

final slides = <SlideInfo>[
  SlideInfo(
      'e-QuizzMath',
      'Desata el genio matemático dentro de ti, un desafío a la vez',
      'assets/images/welcome_messages/1.png'),
  SlideInfo(
      'e-QuizzMath',
      'Conviértete en un maestro a través de emocionantes y divertidos cuestionarios',
      'assets/images/welcome_messages/2.png'),
  SlideInfo(
      'e-QuizzMath',
      'Aprende, juega, domina. ¡Las matemáticas nunca habían sido tan divertidas!',
      'assets/images/welcome_messages/3.png'),
];

class WelcomeMessageScreen extends StatelessWidget {
  const WelcomeMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Sliders
            Expanded(
              child: PageView.builder(
                itemCount: slides.length,
                itemBuilder: (context, index) {
                  final SlideInfo slide = slides[index];

                  return _Slide(
                    title: slide.title,
                    caption: slide.caption,
                    imageUrl: slide.imageUrl,
                  );
                },
              ),
            ),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      context.push('/create-account/personal-info');
                    },
                    child: const Text('EMPEZAR'),
                  ),
                ),
              ],
            ),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    child: const Text('YA TENGO UNA CUENTA'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String caption;
  final String imageUrl;

  const _Slide({
    required this.title,
    required this.caption,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Image
        Image.asset(imageUrl),
        const SizedBox(height: 20),

        // Text
        Text(
          caption,
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
