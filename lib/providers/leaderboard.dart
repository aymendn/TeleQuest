import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nasa/models/game_user.dart';
import 'package:http/http.dart' as http;

final leaderboardProvider =
    StateNotifierProvider<LeaderboardNotifier, List<GameUser>>((ref) {
  return LeaderboardNotifier();
});

final futureLeaderboardProvider = FutureProvider<void>((ref) async {
  await ref.read(leaderboardProvider.notifier).fetchLeaderboard();
});

class LeaderboardNotifier extends StateNotifier<List<GameUser>> {
  LeaderboardNotifier() : super([]);

  

  Future<void> fetchLeaderboard() async {
    final url = Uri.parse(
        'https://nasa-petacode-default-rtdb.firebaseio.com/leaderboard.json');

    final response = await http.get(url);

    if (json.decode(response.body) == null) return;

    final extractedData = Map<String, dynamic>.from(json.decode(response.body));

    final listOfUsers = [
      for (var user in extractedData.values) GameUser.fromMap(user)
    ];

    listOfUsers.sort((a, b) => b.points.compareTo(a.points));

    state = listOfUsers;
  }
}
