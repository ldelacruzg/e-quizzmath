import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard_item.dart';
import 'package:e_quizzmath/infrastructure/models/leaderboard_item_model.dart';
import 'package:e_quizzmath/shared/data/local_learderboard.dart';
import 'package:flutter/material.dart';

class LeaderboardProvider with ChangeNotifier {
  final List<LeaderboardItem> leaderboard = [];

  void init() {
    leaderboard.clear();
    leaderboard.addAll(localLeaderboard
        .map((e) => LeaderboardItemModel.fromJson(e).toLeaderboardItemEntity())
        .toList());

    notifyListeners();
  }
}
