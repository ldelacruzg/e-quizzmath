import 'package:e_quizzmath/config/router/app_router.dart';
import 'package:e_quizzmath/config/theme/app_theme.dart';
import 'package:e_quizzmath/presentation/providers/class_provider.dart';
import 'package:e_quizzmath/presentation/providers/leaderboard_provider.dart';
import 'package:e_quizzmath/presentation/providers/quiz_provider.dart';
import 'package:e_quizzmath/presentation/providers/user_logged_in_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => QuizProvider()..loadQuestions(),
          ),
          ChangeNotifierProvider(
            create: (context) => LeaderboardProvider()..init(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserLoggedInProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => ClassProvider(),
          )
        ],
        child: const MainApp(),
      ),
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
