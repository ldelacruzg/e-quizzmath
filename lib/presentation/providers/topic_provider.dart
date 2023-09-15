import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/topic/entities/topic.dart';
import 'package:e_quizzmath/shared/functions/functions.dart';
import 'package:flutter/material.dart';

class TopicProvider with ChangeNotifier {
  List<Map<String, dynamic>> topicSteps = [
    {
      'title': 'Crear tema',
    },
    {
      'title': 'Crear unidades',
    },
    {
      'title': 'Resumen',
    }
  ];

  bool isLoading = false;
  int currentSteps = 0;
  final List<Topic> _topics = [];

  List<Topic> get topics => _topics;
  int get numSteps => topicSteps.length;

  // Propiedades para el formulario "Crear tema"
  final Topic formCreateTopic = Topic(title: '', description: '');
  final GlobalKey<FormState> formKeyCreateTopic = GlobalKey<FormState>();

  // Propiedades para el formulario "Crear unidad"
  final List<FormCreateUnit> _units = [];
  final FormCreateUnit formCreateUnit = FormCreateUnit();
  final GlobalKey<FormState> formKeyInfoGeneral = GlobalKey<FormState>();
  final GlobalKey<FormState> formKeyPlaylist = GlobalKey<FormState>();
  String urlVideo = '';

  // Funciones para el formulario "Crear unidad"
  List<FormCreateUnit> get units => _units;
  int get numVideos => formCreateUnit.playlist.length;

  void addVideo() {
    if (formKeyPlaylist.currentState!.validate()) {
      formKeyPlaylist.currentState!.save();
      formCreateUnit.playlist.add(urlVideo);
      formKeyPlaylist.currentState!.reset();
    }

    notifyListeners();
  }

  void deleteVideo(int index) {
    formCreateUnit.playlist.removeAt(index);
    notifyListeners();
  }

  void saveFormCreateUnit() {
    if (formKeyInfoGeneral.currentState!.validate()) {
      formKeyInfoGeneral.currentState!.save();

      _units.add(FormCreateUnit.copy(formCreateUnit));

      formKeyInfoGeneral.currentState!.reset();
      formCreateUnit.playlist.clear();
    }

    notifyListeners();
  }

  // Funciones
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

  Future<Topic> _getTopicById(String topicId) async {
    final topicRef = collections[Collections.topics]!.doc(topicId);
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
    if (currentSteps > 0) {
      currentSteps--;
    }
    notifyListeners();
  }

  void reset() {
    currentSteps = 0;
    _units.clear();
    notifyListeners();
  }
}

class FormCreateUnit {
  String title;
  String description;
  String urlVideo;
  late List<String> playlist; // only url video

  FormCreateUnit({
    this.title = '',
    this.description = '',
    this.urlVideo = '',
    List<String>? playlist,
  }) {
    this.playlist = playlist ?? [];
  }

  factory FormCreateUnit.copy(FormCreateUnit formCreateUnit) {
    return FormCreateUnit(
      title: formCreateUnit.title,
      description: formCreateUnit.description,
      playlist: formCreateUnit.playlist.toList(),
    );
  }
}
