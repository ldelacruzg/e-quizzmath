import 'package:e_quizzmath/domain/class/class.dart';
import 'package:e_quizzmath/domain/topic/entities/topic.dart';
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

  int _currentStepIndex = 0;

  List<Topic> get assignedTopics => _assignedTopics;
  List<String> get assignedTopicsIds => _assignedTopicsIds;

  int get numAssignedTopics => _assignedTopics.length;
  int get currentStepIndex => _currentStepIndex;
  int get numSteps => _steps.length;
  Map<String, dynamic> get currentStep => _steps[_currentStepIndex];

  void reset() {
    _currentStepIndex = 0;
    _assignedTopics.clear();
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
}
