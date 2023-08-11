import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeMessageScreen extends StatelessWidget {
  const WelcomeMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/welcome_messages/1.png'),
            const Text('WelcomeMessageScreen'),
            FilledButton(
              onPressed: () => context.push('/home'),
              child: const Text('Home'),
            ),
          ],
        ),
      ),
    );
  }
}
