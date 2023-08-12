import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
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
          if (index != currentScreenIndex) {
            setState(() {
              currentScreenIndex = index;
            });
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
