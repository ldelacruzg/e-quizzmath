import 'package:e_quizzmath/presentation/providers/leaderboard_provider.dart';
import 'package:e_quizzmath/presentation/widgets/home/custom_card_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeStudentScreen extends StatelessWidget {
  const HomeStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardProvider = context.watch<LeaderboardProvider>();

    return Expanded(
      child: GridView.count(
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 2.7),
        crossAxisCount: 2,
        children: [
          GestureDetector(
            onTap: () => context.push('/topics'),
            child: const CustomCardItem(
              color: Colors.orangeAccent,
              title: 'Temas',
              icon: Icons.grid_view_rounded,
            ),
          ),
          GestureDetector(
            onTap: () =>
                {leaderboardProvider.init(), context.push('/leaderboard')},
            child: const CustomCardItem(
              color: Colors.blueAccent,
              title: 'Clasificación',
              icon: Icons.leaderboard_rounded,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/topics'),
            child: const CustomCardItem(
              color: Colors.greenAccent,
              title: 'Crear clase',
              icon: Icons.home_work_rounded,
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/topics'),
            child: const CustomCardItem(
              color: Colors.redAccent,
              title: 'Unirse a clase',
              icon: Icons.task_alt_rounded,
            ),
          ),
        ],
      ),
    );
  }
}
