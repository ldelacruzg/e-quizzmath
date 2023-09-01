import 'package:e_quizzmath/presentation/screens/profile/personal_information/personal_information_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key}) : super(key: key);

  @override
  _ConfigScreenState createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Configuración de perfil'),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                // Espacio horizontal del 4% del ancho de pantalla
                vertical: MediaQuery.of(context).size.width *
                    0.02, // Espacio vertical del 2% del ancho de pantalla
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.person, // Tu icono
                    size: 30, // Tamaño del icono
                    color: Colors.amber, // Color del icono
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.02, // Espacio del 2% del ancho de pantalla
                  ),
                  const Text(
                    "Configuración", // Tu texto
                    style: TextStyle(
                      fontSize: 18, // Tamaño de fuente del texto
                      fontWeight: FontWeight
                          .bold, // Estilo de fuente (puedes ajustarlo)
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward),
                    // Icono del IconButton
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const PersonalInformationScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                // Espacio horizontal del 4% del ancho de pantalla
                vertical: MediaQuery.of(context).size.width *
                    0.02, // Espacio vertical del 2% del ancho de pantalla
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info, // Tu icono
                    size: 30, // Tamaño del icono
                    color: Colors.purple, // Color del icono
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.02, // Espacio del 2% del ancho de pantalla
                  ),
                  const Text(
                    "Sobre e-QuizzMath", // Tu texto
                    style: TextStyle(
                      fontSize: 18, // Tamaño de fuente del texto
                      fontWeight: FontWeight
                          .bold, // Estilo de fuente (puedes ajustarlo)
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.29,
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle), // Icono del IconButton
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.04,
                // Espacio horizontal del 4% del ancho de pantalla
                vertical: MediaQuery.of(context).size.width *
                    0.02, // Espacio vertical del 2% del ancho de pantalla
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.send_to_mobile_sharp, // Tu icono
                    size: 30, // Tamaño del icono
                    color: Colors.deepOrangeAccent, // Color del icono
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width *
                        0.02, // Espacio del 2% del ancho de pantalla
                  ),
                  const Text(
                    "Cerrar Sessión", // Tu texto
                    style: TextStyle(
                      fontSize: 18, // Tamaño de fuente del texto
                      fontWeight: FontWeight
                          .bold, // Estilo de fuente (puedes ajustarlo)
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.38,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    // Icono del IconButton
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('userId');
                        context.go('/login');
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
