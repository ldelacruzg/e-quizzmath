import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';

class CreateAccountPersonalInfoScreen extends StatelessWidget {
  const CreateAccountPersonalInfoScreen({super.key});

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
                                    const WelcomeMessageScreen()),
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
                    "Complete su perfil. No se preocupe, sus datos permanecerán privados y sólo usted podrá verlos.",
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
                          prefixIcon: Icon(Icons.person_2_outlined, size: 25),
                          labelText: "Nombre completo",
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(247, 238, 249, 2),
                          filled: true,
                          prefixIcon:
                              Icon(Icons.calendar_month_outlined, size: 25),
                          labelText: "Fecha de nacimiento",
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(247, 238, 249, 2),
                          filled: true,
                          prefixIcon: Icon(Icons.phone_android, size: 25),
                          labelText: "Número de teléfono",
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
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                          fillColor: Color.fromRGBO(247, 238, 249, 2),
                          filled: true,
                          prefixIcon: Icon(Icons.location_city, size: 25),
                          labelText: "País",
                          labelStyle: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          )),
                    ),
                  ),
                  const SizedBox(height: 200),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CreateAccountCredencialsScreen()),
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
