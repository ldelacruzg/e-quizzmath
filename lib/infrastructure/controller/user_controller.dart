import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/infrastructure/models/user_model.dart';
import 'package:e_quizzmath/presentation/screens/screens.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final password = TextEditingController();
  final pone = TextEditingController();

  late final Rx<User?> firebaseUser;

  Future<void> createUser(UserModel userm) async {
    await _db
        .collection("Users")
        .add(userm.toJS())
        .whenComplete(
          () => Get.snackbar("Success", "Create",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.grey,
              colorText: Colors.grey),
        )
        .catchError((error, stackTrace) {
      Get.snackbar("Error", "Nuevamente",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey,
          colorText: Colors.red);
    });
    Get.to(() => const OPTScreen());
  }

  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  _setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => const WelcomeMessageScreen())
        : Get.offAll(() => const HomeScreen());
  }

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return credential.user;
  }

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }
}
//login and email / passwrod
