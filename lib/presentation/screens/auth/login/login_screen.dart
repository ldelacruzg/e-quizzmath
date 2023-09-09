import 'package:e_quizzmath/presentation/providers/user_logged_in_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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
  late UserLoggedInProvider userLoggedInProvider;

  @override
  void initState() {
    super.initState();
    userLoggedInProvider = context.read<UserLoggedInProvider>();
    emailController.text = 'teacher1@gmail.com';
    passwordController.text = '123456789';
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final String userId = userCredential.user!.uid;
        userLoggedInProvider.getUserLoggedIn(userId).then((value) {
          _saveLoginId(userId).then((value) {
            context.go('/home');
          });
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error al iniciar session verifique los campos');
    }
  }

  Future<void> _saveLoginId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('login_id', id);
    await prefs.setString('type', userLoggedInProvider.userLogged.type);
  }

  void _handleLogin() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (formaKey.currentState!.validate()) {
        await _signIn(emailController.text.toString(),
            passwordController.text.toString());
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Text
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

                // Login form
                Form(
                  key: formaKey,
                  child: Column(
                    children: [
                      // Email TextFormField
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) {
                          emailController.text = value!;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_outlined),
                          labelText: "Correo electrónico",
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password TextFormField
                      TextFormField(
                        controller: passwordController,
                        onSaved: (value) {
                          passwordController.text = value!;
                        },
                        obscureText: !showPassword,
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
                            ),
                          ),
                          prefixIcon: const Icon(Icons.password_outlined),
                          labelText: "Contraseña",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Send Button
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: isLoading ? null : _handleLogin,
                    child: Text(isLoading ? 'CARGANDO...' : 'INICIAR SESIÓN'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
