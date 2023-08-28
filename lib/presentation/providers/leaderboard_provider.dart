import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard_item.dart';
import 'package:e_quizzmath/infrastructure/models/leaderboard_item_model.dart';
import 'package:flutter/material.dart';

class LeaderboardProvider with ChangeNotifier {
  bool isLoading = true;
  final List<LeaderboardItem> leaderboard = [];

  void init() async {
    isLoading = true;
    try {
      CollectionReference collLeaderboard =
          FirebaseFirestore.instance.collection('leaderboard');

      CollectionReference collUser =
          FirebaseFirestore.instance.collection('Users');

      QuerySnapshot querySnapshot = await collLeaderboard.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          var docLeaderboard = doc.data() as Map<String, dynamic>;
          docLeaderboard['id'] = doc.id;

          var userId = docLeaderboard['userId'] as DocumentReference;
          var queryDocUser = await collUser.doc(userId.id).get();
          var docUser = queryDocUser.data() as Map<String, dynamic>;
          docUser['id'] = queryDocUser.id;

          docLeaderboard['userModel'] = docUser;

          //var leaderboardItem = LeaderboardItemModel.fromJson(docLeaderboard);
          leaderboard.add(LeaderboardItemModel.fromJson(docLeaderboard)
              .toLeaderboardItemEntity());
        }

        leaderboard.sort((a, b) => b.score.compareTo(a.score));
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
