import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/class/class.dart';
import 'package:e_quizzmath/domain/user/entities/user.dart';
import 'package:e_quizzmath/infrastructure/models/coll_user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassProvider with ChangeNotifier {
  final List<Class> _classes = [];
  final List<User> _students = [];
  final int selectedClassIndex = 0;

  bool isLoading = false;

  List<Class> get classes => _classes;
  List<User> get students => _students;

  Future<void> loadStudentsByClass(int classIndex) async {
    isLoading = true;
    _students.clear();

    try {
      final classRef = collections[Collections.classes]!.doc(
        _classes[classIndex].id,
      );

      final queryStudents = await collections[Collections.classStudents]!
          .where('classId', isEqualTo: classRef)
          .get();

      if (queryStudents.docs.isNotEmpty) {
        for (var element in queryStudents.docs) {
          final data = element.data() as Map<String, dynamic>;

          final studentRef = data['studentId'] as DocumentReference;

          final student = await studentRef.get();
          if (student.exists) {
            final dataStudent = student.data() as Map<String, dynamic>;
            dataStudent['id'] = student.id;

            _students.add(UserModel.fromJson(dataStudent).toUserEntity());
          }
        }
      }
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  void loadClasses() async {
    isLoading = true;
    _classes.clear();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String teacherId = prefs.getString('login_id') ?? '';
    final teacherRef = collections[Collections.users]?.doc(teacherId);

    try {
      final queryClasses = await collections[Collections.classes]!
          .where('teacherId', isEqualTo: teacherRef)
          .get();

      for (var element in queryClasses.docs) {
        final data = element.data() as Map<String, dynamic>;
        data['id'] = element.id;
        _classes.add(Class.fromJson(data));
      }
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }
}
