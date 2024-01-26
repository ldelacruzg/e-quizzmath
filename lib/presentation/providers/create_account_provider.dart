import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:e_quizzmath/infrastructure/models/user_model.dart';

class CreateAccountProvider extends ChangeNotifier {
  bool loading = false;
  bool error = false;
  String errorMessage = '';

  Future<void> createAccount(UserModel userModel) async {
    loading = true;
    notifyListeners();

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore db = FirebaseFirestore.instance;

      UserCredential authResult = await auth.createUserWithEmailAndPassword(
        email: userModel.email.toString(),
        password: userModel.password.toString(),
      );

      User? user = authResult.user;

      if (user != null) {
        String userUID = user.uid;
        await db.collection("Users").doc(userUID).set(userModel.toJS());
      }

      error = false;
      errorMessage = '';
    } on FirebaseAuthException catch (e) {
      error = true;
      if (e.code == 'email-already-in-use') {
        errorMessage = 'El correo ya esta en uso';
      } else if (e.code == 'weak-password') {
        errorMessage = 'La contraseña es muy debil';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'El correo es invalido';
      } else {
        errorMessage = 'Error desconocido';
      }
    } catch (e) {
      error = true;
      errorMessage = 'Error desconocido';
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
