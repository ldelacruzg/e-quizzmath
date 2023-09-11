import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/topic/entities/topic.dart';
import 'package:e_quizzmath/domain/topic/entities/unit.dart';
import 'package:e_quizzmath/shared/functions/functions.dart';
import 'package:flutter/material.dart';

class TopicProvider with ChangeNotifier {
  bool isLoading = false;
  int numSteps = 2;
  int currentSteps = 1;
  final List<Topic> _topics = [];
  final List<Unit> _units = [];

  List<Topic> get topics => _topics;
  List<Unit> get units => _units;

  void loadTopics() async {
    isLoading = true;
    _topics.clear();

    try {
      final userReference = await Funtions.getUserReference();
      final topics = await collections[Collections.topics]!
          .where('teacherId', isEqualTo: userReference)
          .get();

      for (final topic in topics.docs) {
        final data = topic.data() as Map<String, dynamic>;
        data['id'] = topic.id;
        _topics.add(Topic.fromJson(data));
      }
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  void loadTopicsByClass(String classId) async {
    isLoading = true;
    _topics.clear();

    try {
      final classRef = collections[Collections.classes]!.doc(classId);

      final queryTopics = await collections[Collections.classTopics]!
          .where('classId', isEqualTo: classRef)
          .get();

      if (queryTopics.docs.isNotEmpty) {
        for (var element in queryTopics.docs) {
          final data = element.data() as Map<String, dynamic>;
          final topic = await _getTopicById(data['topicId'].id);
          _topics.add(topic);
        }
      }
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  Future<Topic> _getTopicById(String id) async {
    final topicRef = collections[Collections.topics]!.doc(id);
    final topic = await topicRef.get();

    final data = topic.data() as Map<String, dynamic>;
    data['id'] = topic.id;

    return Topic.fromJson(data);
  }

  void nextStep() {
    if (currentSteps < numSteps) {
      currentSteps++;
    }
    notifyListeners();
  }

  void previousStep() {
    if (currentSteps > 1) {
      currentSteps--;
    }
    notifyListeners();
  }

  void reset() {
    currentSteps = 1;
    _units.clear();
    notifyListeners();
  }
}
