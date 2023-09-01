import 'dart:developer';

import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formaKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool showPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /*
  void SingIn() async {
    //loading
    if (formaKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
    }
    //try sign in
    try {
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
*/

  Future<void> _signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        final String userId = userCredential.user!.uid;
        await _saveLoginId(userId);
        Fluttertoast.showToast(msg: 'Exito iniciar session');
        context.go('/home');
      }

    } catch (e) {
      Fluttertoast.showToast(msg: 'Error al iniciar session verifique los campos');
    }
  }

  Future<void> _saveLoginId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_id', id);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: Form(
                key: formaKey,
                child: Column(
                  children: [
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
                      keyboardType: TextInputType.emailAddress,
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
                          labelText: "CORREO ELECTRÓNICO",
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
                      obscureText: !showPassword,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                              icon: Icon(
                                showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              )),
                          fillColor: const Color.fromRGBO(247, 238, 249, 2),
                          filled: true,
                          prefixIcon: const Icon(Icons.password_outlined, size: 25),
                          labelText: "CONTRASEÑA",
                          labelStyle: const TextStyle(
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
                      onPressed: () {
                        try {
                          if (formaKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true; // Activar el indicador de carga
                            });
                            _signIn(emailController.text.toString(),
                                passwordController.text.toString());



                          }
                        } catch (e) {
                          log('Error al autenticar: $e');
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
                      child: Text(isLoading ? 'CARGANDO...' : 'INICIAR SESSIÓN'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
