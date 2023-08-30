import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_quizzmath/config/firebase/collections_firebase.dart';
import 'package:e_quizzmath/domain/leaderboard/entities/date_range_leaderboard.dart';
import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard.dart';
import 'package:e_quizzmath/domain/leaderboard/entities/leaderboard_item.dart';
import 'package:e_quizzmath/infrastructure/models/leaderboard_item_model.dart';
import 'package:flutter/material.dart';

class LeaderboardProvider with ChangeNotifier {
  bool isLoading = true;
  final List<LeaderboardItem> leaderboard = [];

  void init() async {
    isLoading = true;
    leaderboard.clear();
    try {
      QuerySnapshot querySnapshot = await getLeaderboard();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          var docLeaderboard = doc.data() as Map<String, dynamic>;
          docLeaderboard['id'] = doc.id;

          var userId = docLeaderboard['userId'] as DocumentReference;
          var queryDocUser =
              await collections[Collections.users]!.doc(userId.id).get();
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

  Future<QuerySnapshot> getLeaderboard() async {
    final leaderboardRef = await getCurrentLeaderboard();

    final leaderboard = await collections[Collections.userLeaderboard]!
        .where('leaderboardId', isEqualTo: leaderboardRef)
        .get();

    return leaderboard;
  }

  Future<QuerySnapshot> getLeaderboardByUser() async {
    final leaderboardRef = await getCurrentLeaderboard();
    final userRef = collections[Collections.users]?.doc('EFkiNDtnHDfqOMuoy7dp');

    final leaderboard = await collections[Collections.userLeaderboard]!
        .where('leaderboardId', isEqualTo: leaderboardRef)
        .where('userId', isEqualTo: userRef)
        .get();

    return leaderboard;
  }

  Future<bool> get isCompeting async {
    // User
    final userRef = collections[Collections.users]?.doc('EFkiNDtnHDfqOMuoy7dp');

    // obtener el actual leaderboard
    final leaderboardRef = await getCurrentLeaderboard();

    // obtener el user_leaderboard
    final userLeaderboard = await collections[Collections.userLeaderboard]!
        .where('leaderboardId', isEqualTo: leaderboardRef)
        .where('userId', isEqualTo: userRef)
        .limit(1)
        .get();

    return userLeaderboard.docs.isNotEmpty;
  }

  DateRangeLeaderboard get getDateRangeLeaderboard {
    final currentDate = DateTime.now();

    // Monday
    var monday = currentDate.subtract(Duration(
      days: currentDate.weekday - 1,
    ));
    monday = DateTime(monday.year, monday.month, monday.day);

    // Sunday
    var sunday = monday.add(const Duration(days: 6));
    sunday = DateTime(sunday.year, sunday.month, sunday.day);

    return DateRangeLeaderboard(
        startDate: monday, endDate: sunday, currentDate: currentDate);
  }

  Future<DocumentReference> getCurrentLeaderboard() async {
    final range = getDateRangeLeaderboard;

    final leaderboards = await collections[Collections.leaderboards]!
        .where('startDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(range.startDate))
        .get();

    // buscar el leaderboard actual
    if (leaderboards.docs.isNotEmpty) {
      final leaderboardRef = leaderboards.docs.where((element) {
        final leaderboard =
            Leaderboard.fromFirebase(element.data() as Map<String, dynamic>);

        return range.startDate.isAtSameMomentAs(leaderboard.startDate) &&
            range.endDate.isAtSameMomentAs(leaderboard.endDate);
      });

      return leaderboardRef.first.reference;
    }

    // crear el leaderboard
    final leaderboardRef = await collections[Collections.leaderboards]!.add({
      'startDate': range.startDate,
      'endDate': range.endDate,
    });

    return leaderboardRef;
  }
}
