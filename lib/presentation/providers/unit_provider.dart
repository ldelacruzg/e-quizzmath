import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/topic/entities/unit.dart';
import 'package:flutter/material.dart';

class UnitProvider with ChangeNotifier {
  bool isLoading = false;
  final List<Unit> _units = [];

  List<Unit> get units => _units;

  void loadUnits(DocumentReference topicRef) async {
    isLoading = true;
    _units.clear();
    notifyListeners();

    final units = await collections[Collections.units]!
        .where('topicId', isEqualTo: topicRef)
        .get();

    for (final unit in units.docs) {
      final unitJson = unit.data() as Map<String, dynamic>;
      unitJson['id'] = unit.id;
      _units.add(Unit.fromMap(unitJson));
    }

    isLoading = false;
    notifyListeners();
  }
}
