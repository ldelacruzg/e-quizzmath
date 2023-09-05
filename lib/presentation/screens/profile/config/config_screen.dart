import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatelessWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          _CustomListItemConfig(
            colorIcon: Colors.amber,
            icon: Icons.person_2_rounded,
            title: 'Información personal',
            onTap: () {
              context.push('/profile/personal-information');
            },
          ),
          _CustomListItemConfig(
            colorIcon: Colors.purple,
            icon: Icons.info_outline_rounded,
            title: 'Sobre e-QuizzMath',
            onTap: () {},
          ),
          _CustomListItemConfig(
            colorIcon: Colors.red,
            icon: Icons.logout_rounded,
            title: 'Cerrar sesión',
            onTap: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('¿Estás seguro de cerrar sesión?'),
                actions: [
                  TextButton(
                    onPressed: () => context.pop(false),
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () => context.pop(true),
                    child: const Text('Si'),
                  ),
                ],
              ),
            ).then((value) {
              if (value == true) {
                FirebaseAuth.instance.signOut().then((value) {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('userId');
                    context.go('/');
                  });
                });
              }
            }),
          ),
        ],
      ),
    );
  }
}

class _CustomListItemConfig extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color colorIcon;
  final VoidCallback onTap;

  const _CustomListItemConfig({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.colorIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 20,
      ),
      leading: Icon(
        icon,
        color: colorIcon,
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
    );
  }
}
