import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/infrastructure/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserController {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final pone = TextEditingController();
  final selectedAccountType = ValueNotifier<String>('');
  final accountTypes = ['student', 'teacher'];

  Future<void> createUser(UserModel userm) async {
    try {
      if (userm.email.toString().isNotEmpty &&
          isValidEmail(userm.email.toString())) {
        UserCredential authResult = await _auth.createUserWithEmailAndPassword(
          email: userm.email.toString(),
          password: userm.password.toString(),
        );
        //obtiene el id de la autenticacion
        String userUID = authResult.user!.uid;
        await _db.collection("Users").doc(userUID).set(userm.toJS());
      }
    } catch (e) {
      //print('Error al crear usuario');
    }
  }

  void dispose() {
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    password.dispose();
    pone.dispose();
  }

  bool isValidEmail(String email) {
    // Patrón para verificar si una cadena es una dirección de correo electrónico válida
    final RegExp emailRegExp = RegExp(
      r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
      caseSensitive: false,
    );
    return emailRegExp.hasMatch(email);
  }
}
