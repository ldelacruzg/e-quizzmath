import 'package:e_quizzmath/config/router/app_router.dart';
import 'package:e_quizzmath/config/theme/app_theme.dart';
import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => QuizProvider()..loadQuestions(),
        )
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme(selectedColor: 0).theme(),
    );
  }
}
