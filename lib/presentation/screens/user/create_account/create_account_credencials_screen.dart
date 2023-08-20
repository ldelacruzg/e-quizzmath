import 'package:e_quizzmath/presentation/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';

class CreateAccountCredencialsScreen extends StatelessWidget {
  const CreateAccountCredencialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorSchema = Theme.of(context).colorScheme;
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CreateAccountCredencialsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    "Crear una cuenta ✏️",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Introduzca su nombre de usuario, dirección de correo electrónico y contraseña. Si la olvida, haga clic en Olvidé mi contraseña.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(247, 238, 249, 2),
                          filled: true,
                          prefixIcon: Icon(Icons.verified_user, size: 25),
                          labelText: "Nombre de usuario",
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(247, 238, 249, 2),
                          filled: true,
                          prefixIcon: Icon(Icons.email_outlined, size: 25),
                          labelText: "Correo electrónico",
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      obscureText: true,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(247, 238, 249, 2),
                          filled: true,
                          prefixIcon: Icon(Icons.password_outlined, size: 25),
                          labelText: "Contraseña",
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(height: 260),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 130, vertical: 10),
                      backgroundColor: colorSchema.primary,
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
