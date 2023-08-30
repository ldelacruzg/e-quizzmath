import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard_item.dart';
import 'package:e_quizzmath/presentation/providers/leaderboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = context.watch<LeaderboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF6949FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6949FF),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
        ),
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          child: Text('Clasificación'),
        ),
      ),
      body: leaderboardProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          : const _LeaderboardView(),
    );
  }
}

class _LeaderboardView extends StatelessWidget {
  const _LeaderboardView();

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = context.watch<LeaderboardProvider>();

    return Column(
      children: [
        // Add the first 3
        DefaultTextStyle(
          style: const TextStyle(
            color: Colors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LeaderboardTopItem(
                position: 2,
                item: leaderboardProvider.leaderboard.length > 1
                    ? leaderboardProvider.leaderboard[1]
                    : LeaderboardItem(name: '', score: 0),
              ),
              const SizedBox(width: 10),
              _LeaderboardTopItem(
                  position: 1,
                  item: leaderboardProvider.leaderboard.isNotEmpty
                      ? leaderboardProvider.leaderboard[0]
                      : LeaderboardItem(name: '', score: 0)),
              const SizedBox(width: 10),
              _LeaderboardTopItem(
                  position: 3,
                  item: leaderboardProvider.leaderboard.length > 2
                      ? leaderboardProvider.leaderboard[2]
                      : LeaderboardItem(name: '', score: 0)),
            ],
          ),
        ),

        // Add the rest
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFefeefc),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            child: ListView.builder(
              itemCount: leaderboardProvider.leaderboard.length > 3
                  ? leaderboardProvider.leaderboard.length - 3
                  : 0,
              itemBuilder: (context, index) {
                final currIndex = index + 3;
                return _LeaderboardNormalItem(
                  item: leaderboardProvider.leaderboard[currIndex],
                  position: currIndex + 1,
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class _LeaderboardNormalItem extends StatelessWidget {
  final LeaderboardItem item;
  final int position;

  const _LeaderboardNormalItem({required this.item, required this.position});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          child: Row(
            children: [
              Text('#$position'),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.15,
                height: size.width * 0.15,
                child: RandomAvatar(item.name),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text('${item.score} EXP',
                      style: const TextStyle(fontSize: 12)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _LeaderboardTopItem extends StatelessWidget {
  final LeaderboardItem item;
  final int position;

  const _LeaderboardTopItem({required this.item, required this.position});

  @override
  Widget build(BuildContext context) {
    //final colorSchema = Theme.of(context).colorScheme;
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
                style: TextStyle(fontSize: 30),
              )
            : Column(
                children: [
                  CircleAvatar(
                    radius: 6,
                    backgroundColor: Colors.yellow.shade800,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            border: Border.all(
              color: Colors.white,
              width: 3,
            ),
          ),
          width: size.width * 0.23,
          height: size.width * 0.23,
          child: item.name.isEmpty
              ? const CircleAvatar(
                  backgroundColor: Colors.white,
                )
              : RandomAvatar(item.name),
        ),
        const SizedBox(height: 10),
        Text(
          item.name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(150),
            color: Colors.white,
          ),
          child: Text(
            '${item.score} EXP',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6949FF),
            ),
          ),
        ),
      ],
    );
  }
}
