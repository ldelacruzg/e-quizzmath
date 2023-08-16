import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const WelcomeMessageScreen(),
    ),
    GoRoute(
      path: '/create-account/personal-info',
      builder: (context, state) => const CreateAccountPersonalInfoScreen(),
    ),
    GoRoute(
      path: '/create-account/credencials',
      builder: (context, state) => const CreateAccountCredencialsScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/recover-account/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/recover-account/opt',
      builder: (context, state) => const OPTScreen(),
    ),
    GoRoute(
      path: '/recover-account/create-new-password',
      builder: (context, state) => const CreateNewPasswordScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/topics',
      builder: (context, state) => const TopicsScreen(),
    ),
    GoRoute(
      path: '/topics/:topicId/units',
      builder: (context, state) => const UnitsScreen(),
    ),
    GoRoute(
      path: '/units/:unitId/playlist',
      builder: (context, state) => const PlayListScreen(),
    ),
    GoRoute(
      path: '/quiz',
      builder: (context, state) => const QuizScreen(),
    ),
    GoRoute(
      path: '/leaderboard',
      builder: (context, state) => const LeaderboardScreen(),
    ),
    GoRoute(
      path: '/profile/config',
      builder: (context, state) => const ConfigScreen(),
    ),
    GoRoute(
      path: '/profile/personal-information',
      builder: (context, state) => const PersonalInformationScreen(),
    ),
  ],
);
