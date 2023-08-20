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
      'Desata el geniomatemático dentro de ti, un desafío a la vez',
      'assets/images/welcome_messages/1.png'),
  SlideInfo(
      'e-QuizzMath',
      'Aprende, juega, domina. ¡Las matemáticas nunca habían sido tan divertidas!',
      'assets/images/welcome_messages/3.png'),
  SlideInfo(
      'e-QuizzMath',
      'Conviértete en un maestro a través de emocionantes y divertidos cuestionarios',
      'assets/images/welcome_messages/2.png')
];

class WelcomeMessageScreen extends StatelessWidget {
  const WelcomeMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          physics: const BouncingScrollPhysics(),
          children: slides
              .map((slideData) => _Slide(
                  title: slideData.title,
                  caption: slideData.caption,
                  imageUrl: slideData.imageUrl))
              .toList(),
        ),
        Positioned(
            right: 50,
            width: 300,
            top: 650,
            child: ElevatedButton(
              onPressed: () {
                context.push("/login");
              },
              style: ElevatedButton.styleFrom(
                  primary: Colors.deepPurpleAccent, onPrimary: Colors.white),
              child: const Text('YA TENGO UNA CUENTA'),
            )),
        Positioned(
            right: 50,
            width: 300,
            top: 700,
            child: ElevatedButton(
              child: const Text('EMPEZAR'),
              onPressed: () {
                context.push("/create-account/personal-info");
              },
            )),
      ],
    ));
  }
}

class _Slide extends StatelessWidget {
  final String title;
  final String caption;
  final String imageUrl;

  const _Slide(
      {required this.title, required this.caption, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge;
    final captionStyle = Theme.of(context).textTheme.bodyLarge;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Image(image: AssetImage(imageUrl)),
            const SizedBox(height: 10),
            Text(title, style: titleStyle),
            const SizedBox(height: 10),
            Text(caption, style: captionStyle),
          ],
        ),
      ),
    );
  }
}
