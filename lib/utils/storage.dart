import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/player.dart';

Future<void> saveGameState({
  required List<Player> players,
  required List<List<int>> gameHistory,
  required int currentRound,
  required bool gameInProgress,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final playersJson = jsonEncode(players.map((p) => p.toJson()).toList());
  final gameHistoryJson = jsonEncode(gameHistory);
  final currentGame = {
    'players': players.map((p) => p.toJson()).toList(),
    'gameHistory': gameHistory,
    'currentRound': currentRound,
    'gameInProgress': gameInProgress,
  };
  List<String> lastGamesList = prefs.getStringList('lastGames') ?? [];
  if (!gameInProgress && gameHistory.isNotEmpty) {
    lastGamesList.insert(0, jsonEncode(currentGame));
    if (lastGamesList.length > 5) lastGamesList = lastGamesList.sublist(0, 5);
    await prefs.setStringList('lastGames', lastGamesList);
  }
  await prefs.setString('players', playersJson);
  await prefs.setString('gameHistory', gameHistoryJson);
  await prefs.setInt('currentRound', currentRound);
  await prefs.setBool('gameInProgress', gameInProgress);
}

Future<Map<String, dynamic>> loadGameState() async {
  final prefs = await SharedPreferences.getInstance();
  final playersJson = prefs.getString('players');
  final gameHistoryJson = prefs.getString('gameHistory');
  final round = prefs.getInt('currentRound');
  final inProgress = prefs.getBool('gameInProgress');
  final lastGamesList = prefs.getStringList('lastGames') ?? [];
  List<Player> players = [];
  List<List<int>> gameHistory = [];
  int currentRound = 1;
  bool gameInProgress = false;
  List<Map<String, dynamic>> lastGames = lastGamesList.map((s) => jsonDecode(s) as Map<String, dynamic>).toList();
  if (playersJson != null && gameHistoryJson != null && round != null && inProgress != null) {
    players = (jsonDecode(playersJson) as List).map((p) => Player.fromJson(p)).toList();
    gameHistory = (jsonDecode(gameHistoryJson) as List).map<List<int>>((l) => List<int>.from(l)).toList();
    currentRound = round;
    gameInProgress = inProgress;
  }
  return {
    'players': players,
    'gameHistory': gameHistory,
    'currentRound': currentRound,
    'gameInProgress': gameInProgress,
    'lastGames': lastGames,
  };
} 