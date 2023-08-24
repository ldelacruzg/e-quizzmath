import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard_item.dart';

class LeaderboardItemModel extends LeaderboardItem {
  final int id;

  LeaderboardItemModel({
    required this.id,
    required String name,
    required int score,
    required String avatar,
  }) : super(name: name, score: score, avatar: avatar);

  factory LeaderboardItemModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardItemModel(
      id: json['id'],
      name: json['name'],
      score: json['score'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'score': score,
      'avatar': avatar,
    };
  }

  LeaderboardItem toLeaderboardItemEntity() {
    return LeaderboardItem(
      name: name,
      score: score,
      avatar: avatar,
    );
  }
}
