import 'package:flutter/material.dart';

class MyLeaderboardScreen extends StatelessWidget {
  const MyLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clasificación'),
      ),
      body: const Center(
        child: Text('Tabla de clasificación en desarrollo 💻'),
      ),
    );
  }
}
