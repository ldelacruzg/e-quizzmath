import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/class/class.dart';
import 'package:e_quizzmath/domain/user/entities/user.dart';
import 'package:e_quizzmath/infrastructure/models/coll_user_model.dart';
import 'package:e_quizzmath/shared/functions/functions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassProvider with ChangeNotifier {
  final List<Class> _classes = [];
  final List<User> _students = [];
  final int selectedClassIndex = 0;

  // Propiedades para unirse a una clase
  String findClassCode = '';
  Class classFound = Class(title: '', description: '');
  User teacherOfTheClassFound = User(firstName: '', lastName: '', email: '');

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

  Future<void> loadClassesByStudent() async {
    isLoading = true;
    _classes.clear();

    // obtener el id del estudiante
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final studentId = prefs.getString('login_id') ?? '';
    final studentRef = collections[Collections.users]?.doc(studentId);

    try {
      final queryClasses = await collections[Collections.classStudents]!
          .where('studentId', isEqualTo: studentRef)
          .get();

      if (queryClasses.docs.isNotEmpty) {
        for (var element in queryClasses.docs) {
          final data = element.data() as Map<String, dynamic>;

          final classRef = data['classId'] as DocumentReference;

          final classDoc = await classRef.get();
          if (classDoc.exists) {
            final dataClass = classDoc.data() as Map<String, dynamic>;
            dataClass['id'] = classDoc.id;

            _classes.add(Class.fromJson(dataClass));
          }
        }
      }
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  Future<bool> classCodeExist() async {
    isLoading = true;
    notifyListeners();

    try {
      final queryClass = await collections[Collections.classes]!
          .where('code', isEqualTo: findClassCode)
          .limit(1)
          .get();

      if (queryClass.docs.isNotEmpty) {
        // Obtener datos de la clase encontrada
        final data = queryClass.docs.first.data() as Map<String, dynamic>;
        data['id'] = queryClass.docs.first.id;
        classFound = Class.fromJson(data);

        // Obtener datos del profesor de la clase encontrada
        final teacherRef = data['teacherId'] as DocumentReference;
        final teacher = await teacherRef.get();
        if (teacher.exists) {
          final dataTeacher = teacher.data() as Map<String, dynamic>;
          dataTeacher['id'] = teacher.id;
          teacherOfTheClassFound =
              UserModel.fromJson(dataTeacher).toUserEntity();
        }

        return true;
      }

      classFound = Class(title: '', description: '');
      return false;
    } catch (error) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> joinClass() async {
    isLoading = true;
    notifyListeners();

    final studentRef = await Funtions.getUserReference();
    final classRef =
        Funtions.getDocumentReference(Collections.classes, classFound.id);

    try {
      final newClassStudent =
          await collections[Collections.classStudents]!.add({
        'studentId': studentRef,
        'classId': classRef,
      });

      return newClassStudent.id.isNotEmpty;
    } catch (error) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void restartSearch() {
    findClassCode = '';
    classFound = Class(title: '', description: '');
    teacherOfTheClassFound = User(firstName: '', lastName: '', email: '');
    notifyListeners();
  }
}
