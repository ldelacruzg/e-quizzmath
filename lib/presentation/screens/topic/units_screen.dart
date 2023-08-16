import 'package:flutter/material.dart';

class UnitsScreen extends StatelessWidget {
  const UnitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Algebra Lineal'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Vectores'),
            subtitle: const Text('Aprende los vectores'),
            leading: const Icon(Icons.numbers_rounded),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert_rounded),
            ),
          )
        ],
      ),
    );
  }
}
