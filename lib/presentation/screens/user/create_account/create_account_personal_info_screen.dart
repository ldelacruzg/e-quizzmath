import 'package:e_quizzmath/infrastructure/controller/user_controller.dart';
import 'package:e_quizzmath/infrastructure/models/user_model.dart';
import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateAccountPersonalInfoScreen extends StatelessWidget {
  const CreateAccountPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    final UserController userController = UserController();
    final formaKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  // Text
                  const Text(
                    "Crear una cuenta 👌",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 35),
                  const Text(
                    "Complete su perfil. No se preocupe, sus datos permanecerán privados y sólo usted podrá verlos.",
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 35),

                  // Create account form
                  Form(
                    key: formaKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Nombre
                        TextFormField(
                          controller: controller.firstName,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person_2_outlined),
                            labelText: "Nombres",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese sus nombres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Apellidos
                        TextFormField(
                          controller: controller.lastName,
                          maxLength: 30,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            labelText: "Apellidos",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese sus apellidos';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Celular
                        TextFormField(
                          controller: controller.pone,
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.phone),
                            labelText: "Teléfono",
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: controller.email,
                          maxLength: 30,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: "Correo electrónico",
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Ingrese un email';
                            }
                            if (!userController.isValidEmail(
                                controller.email.text.toString())) {
                              return 'Ingrese un email válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Contraseña
                        TextFormField(
                          obscureText: true,
                          controller: controller.password,
                          maxLength: 15,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            labelText: "Contraseña",
                          ),
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
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),

              // Button
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        if (formaKey.currentState!.validate()) {
                          final users = UserModel(
                              lastName: controller.lastName.text.trim(),
                              firstName: controller.firstName.text.trim(),
                              phone: controller.pone.text.trim(),
                              email: controller.email.text.trim(),
                              password: controller.password.text.trim());
                          userController.createUser(users);

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
                                      child: const Text('Aceptar'),
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
                                      child: const Text('Aceptar'),
                                    )
                                  ],
                                );
                              });
                        }
                      },
                      child: const Text('REGISTRASE'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
