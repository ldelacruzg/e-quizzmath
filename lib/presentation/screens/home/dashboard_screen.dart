import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _CustomItemAction(
                  color: Colors.purpleAccent.shade700,
                  text: 'Unirse',
                  icon: Icons.school_rounded,
                ),
                _CustomItemAction(
                  color: Colors.greenAccent.shade700,
                  text: 'Quiz',
                  icon: Icons.quiz_rounded,
                ),
                _CustomItemAction(
                  color: Colors.orangeAccent.shade700,
                  text: 'Puntuación',
                  icon: Icons.score_rounded,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomItemAction extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;

  const _CustomItemAction({
    required this.color,
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      elevation: 10,
      child: Container(
        width: size.width * 0.3 - (40 * 100 / size.width),
        height: (size.width * 0.3) * 1.5,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 50),
            const SizedBox(height: 10),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
