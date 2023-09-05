import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/user/entities/user.dart';
import 'package:e_quizzmath/infrastructure/models/coll_user_model.dart';
import 'package:flutter/material.dart';

class UserLoggedInProvider with ChangeNotifier {
  late String _uid;
  late User _userLogged;

  String get uid => _uid;
  User get userLogged => _userLogged;

  set uid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  Future<void> getUserLoggedIn(String uid) async {
    // buscar el usuario en firebase
    final queryUser = await collections[Collections.users]!.doc(uid).get();
    final data = queryUser.data() as Map<String, dynamic>;
    data['id'] = uid;

    _userLogged = UserModel.fromJson(data).toUserEntity();
    notifyListeners();
  }
}
