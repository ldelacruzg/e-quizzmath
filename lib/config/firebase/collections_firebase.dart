import 'package:cloud_firestore/cloud_firestore.dart';

enum Collections {
  users,
  leaderboards,
  userLeaderboard,
  quizzes,
  questions,
  assignedQuestions,
  units,
  topics,
  classes,
  classStudents
}

Map<Collections, CollectionReference> collections = {
  Collections.users: FirebaseFirestore.instance.collection('Users'),
  Collections.leaderboards:
      FirebaseFirestore.instance.collection('leaderboards'),
  Collections.userLeaderboard:
      FirebaseFirestore.instance.collection('user_leaderboard'),
  Collections.quizzes: FirebaseFirestore.instance.collection('quizzes'),
  Collections.questions: FirebaseFirestore.instance.collection('questions'),
  Collections.assignedQuestions:
      FirebaseFirestore.instance.collection('assigned_questions'),
  Collections.units: FirebaseFirestore.instance.collection('units'),
  Collections.topics: FirebaseFirestore.instance.collection('topics'),
  Collections.classes: FirebaseFirestore.instance.collection('classes'),
  Collections.classStudents:
      FirebaseFirestore.instance.collection('class_students'),
};
