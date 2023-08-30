import 'package:cloud_firestore/cloud_firestore.dart';

class Leaderboard {
  final DateTime startDate;
  final DateTime endDate;

  Leaderboard({
    required this.startDate,
    required this.endDate,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  factory Leaderboard.fromFirebase(Map<String, dynamic> json) {
    var startDate = (json['startDate'] as Timestamp).toDate();
    startDate = DateTime(startDate.year, startDate.month, startDate.day);

    var endDate = (json['endDate'] as Timestamp).toDate();
    endDate = DateTime(endDate.year, endDate.month, endDate.day);

    return Leaderboard(
      startDate: startDate,
      endDate: endDate,
    );
  }
}
