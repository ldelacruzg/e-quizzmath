import 'package:cloud_firestore/cloud_firestore.dart';

enum Collections {
  users,
  leaderboards,
  userLeaderboard,
}

Map<Collections, CollectionReference> collections = {
  Collections.users: FirebaseFirestore.instance.collection('Users'),
  Collections.leaderboards:
      FirebaseFirestore.instance.collection('leaderboards'),
  Collections.userLeaderboard:
      FirebaseFirestore.instance.collection('user_leaderboard'),
};
