import 'package:e_quizzmath/presentation/providers/leaderboard_provider.dart';
import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    final leaderProvider = context.watch<LeaderboardProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('e-QuizzMath'),
      ),
      body: [
        const DashboardScreen(), // Dashboard
        const TopicsScreen(),
        const LeaderboardScreen(),
        const ConfigScreen()
      ][currentScreenIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentScreenIndex,
        onDestinationSelected: (index) {
          if (index != currentScreenIndex && index != 2) {
            setState(() {
              currentScreenIndex = index;
            });
          }

          if (index == 2) {
            context.go('/leaderboard');
            leaderProvider.init();
          }
        },
        destinations: const [
          NavigationDestination(
            label: 'Inicio',
            icon: Icon(Icons.home_filled),
          ),
          NavigationDestination(
            label: 'Temas',
            icon: Icon(Icons.grid_view_rounded),
          ),
          NavigationDestination(
            label: 'Clasificación',
            icon: Icon(Icons.leaderboard_rounded),
          ),
          NavigationDestination(
            label: 'Perfil',
            icon: Icon(Icons.person_2_rounded),
          ),
        ],
      ),
    );
  }
}
