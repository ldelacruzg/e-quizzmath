import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/class/class.dart';
import 'package:e_quizzmath/domain/topic/entities/topic.dart';
import 'package:e_quizzmath/shared/functions/functions.dart';
import 'package:flutter/material.dart';

class CreateClassProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _steps = [
    {
      'title': 'Crear clase',
      'description': 'Escribe el título de la clase',
    },
    {
      'title': 'Asignar temas',
      'description': 'Escribe la descripción de la clase',
    },
    {
      'title': 'Resumen',
      'description': 'Comparte el código de la clase',
    }
  ];

  final List<Topic> _assignedTopics = [];
  final Topic formTopic = Topic(title: '', description: '');
  final Class formClass = Class(title: '', description: '');
  final List<String> _assignedTopicsIds = [];
  bool isLoading = false;
  String newClassCode = '';

  // Propiedades del formulario
  final formKeyCreateClass = GlobalKey<FormState>();
  final formCreateClass = FormCreateClass();

  int _currentStepIndex = 0;

  List<Topic> get assignedTopics => _assignedTopics;
  List<String> get assignedTopicsIds => _assignedTopicsIds;

  int get numAssignedTopics => _assignedTopics.length;
  int get currentStepIndex => _currentStepIndex;
  int get numSteps => _steps.length;
  Map<String, dynamic> get currentStep => _steps[_currentStepIndex];

  void reset() {
    _currentStepIndex = 0;
    formCreateClass.reset();
    notifyListeners();
  }

  void nextStep() {
    if (_currentStepIndex < numSteps - 1) {
      _currentStepIndex++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStepIndex > 0) {
      _currentStepIndex--;
      notifyListeners();
    }
  }

  void addTopic(Topic formTopic) {
    _assignedTopics.add(formTopic);
    notifyListeners();
  }

  void deleteTopic(int index) {
    _assignedTopics.removeAt(index);
    notifyListeners();
  }

  // assig topic id
  void addTopicId(String id) {
    _assignedTopicsIds.add(id);
    notifyListeners();
  }

  // remove topic id
  void deleteTopicId(String id) {
    _assignedTopicsIds.remove(id);
    notifyListeners();
  }

  bool validateCreateClass() {
    if (formKeyCreateClass.currentState!.validate()) {
      formKeyCreateClass.currentState!.save();
      return true;
    }

    return false;
  }

  bool hasAssignTopicRef() {
    return formCreateClass.topicsRefs.isNotEmpty;
  }

  void addTopicRef(String topicId) {
    final topicRef = Funtions.getDocumentReference(Collections.topics, topicId);
    formCreateClass.topicsRefs.add(topicRef);
    notifyListeners();
  }

  void deleteTopicRef(String topicId) {
    final topicRef = Funtions.getDocumentReference(Collections.topics, topicId);
    formCreateClass.topicsRefs.remove(topicRef);
    notifyListeners();
  }

  bool hasTopicRef(String topicId) {
    final topicRef = Funtions.getDocumentReference(Collections.topics, topicId);
    return formCreateClass.topicsRefs.contains(topicRef);
  }

  List<Topic> getAssignedTopics(List<Topic> topics) {
    final List<Topic> assignedTopics = [];

    for (final topic in topics) {
      if (hasTopicRef(topic.id)) {
        assignedTopics.add(topic);
      }
    }

    return assignedTopics;
  }

  // guardar la clase en firebase
  Future<bool> saveFormCreateClass() async {
    isLoading = true;
    notifyListeners();

    try {
      final userReference = await Funtions.getUserReference();

      // crear clase
      final newClass = formCreateClass.toClass();
      final classJson = newClass.toJson();
      classJson['teacherId'] = userReference;

      // guardar la clase
      final classRef = await collections[Collections.classes]!.add(classJson);

      // actualizar el codigo de la clase creada
      final classCode = classRef.id;
      await classRef.update({'code': classCode});
      newClassCode = classCode;

      // crear las relaciones de los temas con la clase
      for (final topicRef in formCreateClass.topicsRefs) {
        final classTopicJson = {
          'classId': classRef,
          'topicId': topicRef,
        };

        await collections[Collections.classTopics]!.add(classTopicJson);
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

class FormCreateClass {
  String title;
  String description;
  late List<DocumentReference> topicsRefs;

  FormCreateClass({
    this.title = '',
    this.description = '',
    List<DocumentReference>? topicsRefs,
  }) {
    this.topicsRefs = topicsRefs ?? [];
  }

  void reset() {
    title = '';
    description = '';
    topicsRefs = [];
  }

  Class toClass() {
    return Class(
      title: title,
      description: description,
    );
  }
}
