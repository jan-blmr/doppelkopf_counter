import 'package:flutter/material.dart';
import '../models/player.dart';
import 'game_history_page.dart';

class PastGamesPage extends StatelessWidget {
  final List<Map<String, dynamic>> lastGames;
  final Function(int) onSelect;
  const PastGamesPage({super.key, required this.lastGames, required this.onSelect});

  String _getPlayerNames(Map<String, dynamic> game) {
    final players = (game['players'] as List).map((p) => Player.fromJson(p)).toList();
    return players.map((p) => p.name).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vergangene Spiele')),
      body: ListView.separated(
        itemCount: lastGames.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, i) {
          final game = lastGames[i];
          final rounds = (game['gameHistory'] as List).length;
          final playerNames = _getPlayerNames(game);
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text('Spiel ${i + 1}'),
            subtitle: Text('$rounds Runden - $playerNames'),
            onTap: () {
              final players = (game['players'] as List).map((p) => Player.fromJson(p)).toList();
              final gameHistory = (game['gameHistory'] as List).map<List<int>>((l) => List<int>.from(l)).toList();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => GameHistoryPage(
                    history: gameHistory,
                    players: players,
                    onEditRound: (roundIndex) {
                      // Disable editing for past games
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Vergangene Spiele können nicht bearbeitet werden')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
} 