class LeaderboardItem {
  final String name;
  final int score;
  final String avatar;

  LeaderboardItem({
    required this.name,
    required this.score,
    this.avatar = '',
  });
}
