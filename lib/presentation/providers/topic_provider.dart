import 'package:cloud_firestore/cloud_firestore.dart';
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
    formCreateUnit.playlist.add(urlVideo);
    formKeyPlaylist.currentState!.reset();
    formCreateUnit.urlVideo = '';

    notifyListeners();
  }

  void deleteVideo(int index) {
    formCreateUnit.playlist.removeAt(index);
    notifyListeners();
  }

  bool saveFormCreateUnit() {
    if (formKeyInfoGeneral.currentState!.validate() && numVideos > 0) {
      formKeyInfoGeneral.currentState!.save();

      _units.add(FormCreateUnit.copy(formCreateUnit));

      formKeyInfoGeneral.currentState!.reset();
      formCreateUnit.playlist.clear();

      notifyListeners();
      return true;
    }

    return false;
  }

  void deleteUnit(int index) {
    _units.removeAt(index);
    notifyListeners();
  }

  // Funciones para el formulario "Crear tema"
  void validateFormCreateTopic() {
    if (formKeyCreateTopic.currentState!.validate()) {
      formKeyCreateTopic.currentState!.save();
      nextStep();
    }
  }

  // función para guardar el tema en firebase
  Future<bool> saveFormCreateTopic() async {
    isLoading = true;
    notifyListeners();

    try {
      // tengo que guardar el tema
      // obtener el id del teacher logueado
      final teacherRef = await Funtions.getUserReference();
      final topic = Topic(
        title: formCreateTopic.title,
        description: formCreateTopic.description,
      );

      final topicJson = topic.toJson();
      topicJson['teacherId'] = teacherRef;

      final newTopicRef = await collections[Collections.topics]!.add(topicJson);

      // tengo que guardar las unidades con la playlist
      for (final unit in _units) {
        final unitJson = unit.toJson();
        unitJson['topicId'] = newTopicRef;

        await collections[Collections.units]!.add(unitJson);
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void loadingDelay() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 3));
    isLoading = false;
    notifyListeners();
  }

  // Funciones
  List<Topic> getTopicsByIds(List<DocumentReference> topicIds) {
    final List<Topic> topics = [];

    for (final topicId in topicIds) {
      final topic = _topics.firstWhere((element) => element.id == topicId.id);
      topics.add(topic);
    }

    return topics;
  }

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
    formCreateTopic.title = '';
    formCreateTopic.description = '';
    notifyListeners();
  }

  void saveTopic() {}
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

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'playlist': playlist,
    };
  }
}
