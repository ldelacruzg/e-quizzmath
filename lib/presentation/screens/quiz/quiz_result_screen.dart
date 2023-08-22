import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class QuizResultScreen extends StatelessWidget {
  const QuizResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    final quizProvider = context.watch<QuizProvider>();

    return Scaffold(
      appBar: null,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '¡Lección completada!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: colorSchema.primary,
              ),
            ),
            Image.asset('assets/images/quiz/completed.png'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ScoreItem(
                  title: 'Total EXP',
                  value: quizProvider.totalExp.toString(),
                  icon: Icons.star,
                  color: Colors.orangeAccent,
                ),
                _ScoreItem(
                  title: 'Tiempo',
                  value: quizProvider.shortTimer,
                  icon: Icons.timer,
                  color: Colors.greenAccent,
                ),
                _ScoreItem(
                  title: 'Porcentaje',
                  value: quizProvider.accurence.toStringAsFixed(2),
                  icon: Icons.check_circle,
                  color: Colors.redAccent,
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FilledButton(
                      onPressed: () {
                        quizProvider.reset();
                        context.go('/home');
                      },
                      child: const Text('CONTINUAR'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final IconData icon;

  const _ScoreItem({
    required this.color,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color),
      ),
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: color,
                  ),
                  const SizedBox(width: 5),
                  Text(value, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
