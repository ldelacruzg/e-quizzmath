import 'package:e_quizzmath/presentation/providers/leaderboard_provider.dart';
import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:random_avatar/random_avatar.dart';

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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: _CustomAppBar(),
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

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AppBar(
      // ignore: prefer_const_constructors
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 20, child: RandomAvatar('Luis De La Cruz')),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hola,',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'Luis De La Cruz',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Text(
              '120 EXP',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
