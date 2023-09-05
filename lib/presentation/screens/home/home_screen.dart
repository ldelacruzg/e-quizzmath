import 'package:e_quizzmath/presentation/providers/leaderboard_provider.dart';
import 'package:e_quizzmath/presentation/providers/user_logged_in_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: _CustomAppBar(),
      ),
      body: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userLoggedInProvider = context.watch<UserLoggedInProvider>();
    final leaderboardProvider = context.watch<LeaderboardProvider>();
    return Padding(
      padding: const EdgeInsets.only(top: 40, right: 20, left: 20, bottom: 20),
      child: Column(
        children: [
          // Hola
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Hola,',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),

          // Nombre
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              userLoggedInProvider.userLogged.fullName,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Actions
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 2.7),
              crossAxisCount: 2,
              children: [
                GestureDetector(
                  onTap: () => context.push('/topics'),
                  child: const _CustomCardItem(
                    color: Colors.orangeAccent,
                    title: 'Temas',
                    icon: Icons.grid_view_rounded,
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    leaderboardProvider.init(),
                    context.push('/leaderboard')
                  },
                  child: const _CustomCardItem(
                    color: Colors.blueAccent,
                    title: 'Clasificación',
                    icon: Icons.leaderboard_rounded,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomCardItem extends StatelessWidget {
  final Color color;
  final String title;
  final IconData icon;

  const _CustomCardItem({
    required this.color,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}

/* class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    final userLoggedInProvider = context.watch<UserLoggedInProvider>();

    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                  radius: 20,
                  child:
                      RandomAvatar(userLoggedInProvider.userLogged.fullName)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Hola,',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    userLoggedInProvider.userLogged.fullName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
 */

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar();

  @override
  Widget build(BuildContext context) {
    final userLoggedInProvider = context.watch<UserLoggedInProvider>();

    return AppBar(
      title: const Text('e-QuizzMath'),
      actions: [
        GestureDetector(
          onTap: () => context.push('/profile/config'),
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 20,
              child: RandomAvatar(userLoggedInProvider.userLogged.fullName),
            ),
          ),
        ),
      ],
    );
  }
}
