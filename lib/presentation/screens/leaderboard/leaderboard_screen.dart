import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard_item.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Add the first 3
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _LeaderboardTopItem(
              position: 2,
              item: LeaderboardItem(
                name: 'John Doe',
                score: 854,
                avatar: 'assets/images/avatars/man.jpg',
              ),
            ),
            const SizedBox(width: 10),
            _LeaderboardTopItem(
              position: 1,
              item: LeaderboardItem(
                name: 'Jessi Due',
                score: 1000,
                avatar: 'assets/images/avatars/woman.png',
              ),
            ),
            const SizedBox(width: 10),
            _LeaderboardTopItem(
              position: 3,
              item: LeaderboardItem(
                name: 'Ana Due',
                score: 765,
                avatar: 'assets/images/avatars/woman2.jpg',
              ),
            ),
          ],
        ),

        // Add the rest
      ],
    );
  }
}

class _LeaderboardTopItem extends StatelessWidget {
  final LeaderboardItem item;
  final int position;

  const _LeaderboardTopItem({required this.item, required this.position});

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        (position != 1)
            ? const SizedBox(height: 100)
            : const SizedBox(height: 0),
        Text(
          position.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        (position == 1)
            ? const Text(
                '👑',
                style: TextStyle(fontSize: 35),
              )
            : Column(
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: colorSchema.primary,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            border: Border.all(
              color: colorSchema.primary,
              width: 3,
            ),
          ),
          width: size.width * 0.23,
          height: size.width * 0.23,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.asset(
              item.avatar,
              width: 120,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          item.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          item.score.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorSchema.primary,
          ),
        ),
      ],
    );
  }
}
