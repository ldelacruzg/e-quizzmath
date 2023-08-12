import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      crossAxisSpacing: 10,
      crossAxisCount: 2,
      children: const [
        _TopicItem(
          title: 'Álgebra Lineal',
          urlImage: 'assets/images/topics/algebra-lineal.png',
        ),
      ],
    );
  }
}

class _TopicItem extends StatelessWidget {
  final String title;
  final String urlImage;

  const _TopicItem({
    required this.title,
    required this.urlImage,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        side: BorderSide(color: colorTheme.outline),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(urlImage, width: 70),
                IconButton.filled(
                  onPressed: () {
                    context.push('/topics/1/units', extra: {'topicId': 2});
                  },
                  icon: const Icon(Icons.play_arrow_rounded),
                )
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
