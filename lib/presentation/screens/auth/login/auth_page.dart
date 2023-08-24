import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';

// Cuando ocurre un error al registrarse
class SignUpFailure implements Exception {}

// Cuando ocurre un error en el login
class LogInWithEmailAndPasswordFailure implements Exception {}

// Cuando ocurre un error con el login de google
class LogInWithGoogleFailure implements Exception {}

// Cuando ocurre un error cuando cerramos sesion
class LogOutFailure implements Exception {}

class AuthenticationRepository {
  AuthenticationRepository(
      {required firebase_auth.FirebaseAuth firebaseAuth,
      required GoogleSignIn googleSignIn})
      : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  // Login con email y password
  Future<void> logInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  // cerrar sesion
  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
    } on Exception {
      throw LogOutFailure();
    }
  }
}
