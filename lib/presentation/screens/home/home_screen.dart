import 'package:e_quizzmath/presentation/providers/user_logged_in_provider.dart';
import 'package:e_quizzmath/presentation/screens/home/home_student_screen.dart';
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
          const SizedBox(height: 20),

          // Actions
          // Estas acciones cambia dependiendo del tipo de usuario
          (userLoggedInProvider.userLogged.type == 'teacher')
              ? const HomeTeacherScreen()
              : const HomeStudentScreen(),
        ],
      ),
    );
  }
}

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
