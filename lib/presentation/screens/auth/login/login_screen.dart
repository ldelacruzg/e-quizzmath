import 'package:e_quizzmath/infrastructure/controller/user_controller.dart';
import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final formaKey = GlobalKey<FormState>();
  bool isLoading = false;

  void SingIn() async {
    //loading
    if (formaKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
     }
    //try sign in
    try {
      print(emailController.text);
      print(passwordController.text + "hola");
      await _auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const HomeScreen())
      );
      // pop the loading circle
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Error en el inicio de sesión')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _signInWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // El usuario ha iniciado sesión exitosamente
      print('Usuario autenticado: ${userCredential.user?.email}');
    } catch (e) {
      // Error al autenticar al usuario
      print('Error al autenticar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Form(
                key: formaKey,
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
                            context.push("/");
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 13),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "¡Hola! 👋",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: emailController,
                      onSaved: (value) {
                        emailController.text = value!;
                      },
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
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: passwordController,
                      onSaved: (value) {
                        passwordController.text = value!;
                      },
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
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen()),
                        );
                      },
                      child: const Text('¿Olvidó su contraseña?'),
                    ),
                    const SizedBox(height: 280),
                    ElevatedButton(
                      onPressed: ()  {
                        try {
                          SingIn();

                        } catch (e) {
                          print('Error al autenticar: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Error en el inicio de sesión')),
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepPurpleAccent,
                          minimumSize: const Size(double.infinity, 40)),
                      child: Text(isLoading ? 'Cargando...' : 'Iniciar Sesión'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
