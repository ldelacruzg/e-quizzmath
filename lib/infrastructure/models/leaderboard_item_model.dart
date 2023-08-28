import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard_item.dart';
import 'package:e_quizzmath/infrastructure/models/coll_user_model.dart';

class LeaderboardItemModel {
  final String id;
  final int score;
  final UserModel userModel;

  LeaderboardItemModel({
    required this.id,
    required this.score,
    required this.userModel,
  });

  factory LeaderboardItemModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardItemModel(
      id: json['id'],
      score: json['score'],
      userModel: UserModel.fromJson(json['userModel']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'userModel': userModel.toJson(),
    };
  }

  LeaderboardItem toLeaderboardItemEntity() {
    return LeaderboardItem(
      name: '${userModel.firstName} ${userModel.lastName}',
      score: score,
    );
  }
}
