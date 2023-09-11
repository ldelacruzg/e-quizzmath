import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Funtions {
  static List<int> getRandomItems(int totalItems, int max) {
    final random = Random();
    final items = <int>[];

    while (items.length < totalItems) {
      final item = random.nextInt(max);
      if (!items.contains(item)) {
        items.add(item);
      }
    }

    return items;
  }

  static Future<String> getUserIdLogged() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('login_id') ?? '';
  }

  static Future<DocumentReference<Object?>> getUserReference() async {
    final id = await getUserIdLogged();
    return collections[Collections.users]!.doc(id);
  }
}
