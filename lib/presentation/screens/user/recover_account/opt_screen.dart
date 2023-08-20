import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';

class OPTScreen extends StatelessWidget {
  const OPTScreen({super.key});

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
                                builder: (context) =>
                                    const ForgotPasswordScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 13),
                  const Text(
                    "Tienes correo",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Hemos enviado este código de verificación a tu dirección de correo electrónico. Comprueba tu correo electrónico e introduce el código a continuación.",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // Espacio uniforme entre los cuadros
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey,
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey,
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey,
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey,
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "¿No has recibido el correo electrónico?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 400),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CreateNewPasswordScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 130, vertical: 10),
                        primary: Colors.deepPurpleAccent,
                        onPrimary: Colors.white),
                    child: const Text('Continuar'),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
