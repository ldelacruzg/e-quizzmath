import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Text('Ver Playlist'),
                  onTap: () {
                    context.push(
                      '/units/:unitId/playlist',
                      extra: {'unitId': '1'},
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Text('Iniciar Cuestionario'),
                  onTap: () {
                    context.push('/quiz');
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
