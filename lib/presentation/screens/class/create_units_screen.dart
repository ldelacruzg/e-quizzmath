import 'package:flutter/material.dart';

class CreateUnitScreen extends StatelessWidget {
  const CreateUnitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear unidad'),
      ),
      body: const Center(
        child: Text('Crear unidad'),
      ),
    );
  }
}
