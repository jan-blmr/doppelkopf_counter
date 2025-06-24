import 'package:flutter/material.dart';

class PastGamesPage extends StatelessWidget {
  final List<Map<String, dynamic>> lastGames;
  final Function(int) onSelect;
  const PastGamesPage({super.key, required this.lastGames, required this.onSelect});

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
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text('Spiel ${i + 1}'),
            subtitle: Text('$rounds Runden'),
            onTap: () => onSelect(i),
          );
        },
      ),
    );
  }
} 