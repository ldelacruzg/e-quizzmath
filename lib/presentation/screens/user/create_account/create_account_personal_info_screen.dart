import 'package:e_quizzmath/infrastructure/controller/user_controller.dart';
import 'package:e_quizzmath/infrastructure/models/user_model.dart';
import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CreateAccountPersonalInfoScreen extends StatelessWidget {
  const CreateAccountPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final formaKey = GlobalKey<FormState>();
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Form(
              key: formaKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Crear una cuenta 👌",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Complete su perfil. No se preocupe, sus datos permanecerán privados y sólo usted podrá verlos.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                      color: Colors.black,
                    ),
                  ),
                  TextFormField(
                    controller: controller.firstName,
                    maxLength: 30,
                    decoration: const InputDecoration(
                        fillColor: Color.fromRGBO(247, 238, 249, 2),
                        filled: true,
                        prefixIcon: Icon(Icons.person_2_outlined, size: 20),
                        labelText: "NOMBRES",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese sus nombres';
                      }
                    },
                  ),
                  TextFormField(
                    controller: controller.lastName,
                    maxLength: 30,
                    decoration: const InputDecoration(
                        fillColor: Color.fromRGBO(247, 238, 249, 2),
                        filled: true,
                        prefixIcon: Icon(Icons.person, size: 20),
                        labelText: "APELLIDOS",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese sus apellidos';
                      }
                    },
                  ),
                  TextFormField(
                    controller: controller.pone,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        fillColor: Color.fromRGBO(247, 238, 249, 2),
                        filled: true,
                        prefixIcon: Icon(Icons.phone, size: 20),
                        labelText: "CELULAR",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        )),
                  ),
                  TextFormField(
                    controller: controller.email,
                    maxLength: 30,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        fillColor: Color.fromRGBO(247, 238, 249, 2),
                        filled: true,
                        prefixIcon: Icon(Icons.email, size: 20),
                        labelText: "E-MAIL",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese un email';
                      }
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: controller.password,
                    maxLength: 15,
                    decoration: const InputDecoration(
                        fillColor: Color.fromRGBO(247, 238, 249, 2),
                        filled: true,
                        prefixIcon: Icon(Icons.password, size: 20),
                        labelText: "CONTRASEÑA",
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        )),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Ingrese una contraseña';
                      }
                      if (value.length < 9) {
                        return 'La contraseña debe tener al menos 9 caracteres';
                      }
                      return null; // Retorna null si la validación es exitosa
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (formaKey.currentState!.validate()) {
                              final users = UserModel(
                                  lastName: controller.lastName.text.trim(),
                                  firstName: controller.firstName.text.trim(),
                                  phone: controller.pone.text.trim(),
                                  email: controller.email.text.trim(),
                                  password: controller.password.text.trim());
                              UserController.instance.createUser(users);

                              formaKey.currentState!.reset();
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Cuenta creada ✅'),
                                      content: const Text(
                                          'Se ha creado correctamente su usuario'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: Text('Aceptar'),
                                        ),
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Alerta 🚧'),
                                      content: const Text(
                                          'Se han encontrado campos inválidos'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('Aceptar'),
                                        )
                                      ],
                                    );
                                  });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.deepPurpleAccent,
                          ),
                          child: const Text('Aceptar'),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
