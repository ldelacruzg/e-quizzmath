import 'package:e_quizzmath/infrastructure/models/user_model.dart';
import 'package:e_quizzmath/presentation/providers/create_account_provider.dart';
import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountPersonalInfoScreen extends StatelessWidget {
  const CreateAccountPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const SingleChildScrollView(
        child: _CreateAccountView(),
      ),
    );
  }
}

class _CreateAccountView extends StatelessWidget {
  const _CreateAccountView();

  void onPressed(BuildContext context, UserModel userData) {
    final state = context.read<CreateAccountProvider>();

    state.createAccount(userData).then((value) {
      if (state.error) {
        throw Exception(state.errorMessage);
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Cuenta creada ✅'),
          content: const Text('Se ha creado correctamente su usuario'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    }).catchError((error) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error ❌'),
          content: Text(state.errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          const Text(
            'Crear una cuenta ✍️',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 35),
          const Text(
            'Complete su perfil. No se preocupe, sus datos permanecerán privados y sólo usted podrá verlos.',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),

          // Form
          const SizedBox(height: 35),
          _CreateAccountForm(onPressed: onPressed),
        ],
      ),
    );
  }
}

class _CreateAccountForm extends StatefulWidget {
  final void Function(BuildContext context, UserModel userData) onPressed;

  const _CreateAccountForm({
    required this.onPressed,
  });

  @override
  State<_CreateAccountForm> createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<_CreateAccountForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String _seletedAccountType = '';
  bool showPassword = false;

  bool isValidEmail(String email) {
    // Patrón para verificar si una cadena es una dirección de correo electrónico válida
    final RegExp emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
      caseSensitive: false,
    );
    return emailRegExp.hasMatch(email);
  }

  UserModel get userData => UserModel(
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        phone: phone.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        type: _seletedAccountType,
      );

  void _onPressed() {
    if (_formKey.currentState!.validate()) {
      widget.onPressed.call(context, userData);
    }
  }

  @override
  void dispose() {
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CreateAccountProvider>();

    return Form(
      key: _formKey,
      child: Column(
        children: [
          // tipo de cuenta
          DropdownButtonFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.account_circle_rounded),
              labelText: "Tipo de cuenta",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _seletedAccountType = value.toString();
                });
              }
            },
            items: const [
              DropdownMenuItem(
                value: 'student',
                child: Text('Estudiante'),
              ),
              DropdownMenuItem(
                value: 'teacher',
                child: Text('Profesor'),
              ),
            ],
            validator: (value) {
              if (value == null) {
                return 'Seleccione un tipo de cuenta';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Nombre
          TextFormField(
            controller: firstName,
            maxLength: 30,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person_2_outlined),
              labelText: "Nombre *",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese sus nombres';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Apellido
          TextFormField(
            controller: lastName,
            maxLength: 30,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.person),
              labelText: "Apellidos",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese sus apellidos';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Telefono
          TextFormField(
            controller: phone,
            maxLength: 10,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.phone),
              labelText: "Teléfono",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email
          TextFormField(
            controller: email,
            maxLength: 50,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.email),
              labelText: "Correo electrónico",
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese un email';
              }

              if (!isValidEmail(email.text.toString())) {
                return 'Ingrese un email válido';
              }

              return null;
            },
          ),
          const SizedBox(height: 16),

          // Contraseña
          TextFormField(
            obscureText: !showPassword,
            controller: password,
            maxLength: 50,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.password),
              labelText: "Contraseña",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Ingrese una contraseña';
              }
              if (value.length < 9) {
                return 'La contraseña debe tener al menos 9 caracteres';
              }
              return null;
            },
          ),

          // Button
          const SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: FilledButton(
                  onPressed: state.loading ? null : _onPressed,
                  child: Text(state.loading ? 'CARGANDO...' : 'REGISTRARSE'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
