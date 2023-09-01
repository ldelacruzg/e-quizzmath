import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';

class CreateNewPasswordScreen extends StatelessWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OPTScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    "¡Hola!",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
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
                          labelText: "Crear nueva contraseña",
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
                          labelText: "Confirmar nueva contraseña",
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ),
                  ),

                  const SizedBox(height: 420),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.deepPurpleAccent, minimumSize: const Size(double.infinity, 40)),
                    child: const Text('Continuar'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
