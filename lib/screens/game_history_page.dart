import 'package:flutter/material.dart';
import '../models/player.dart';

class GameHistoryPage extends StatelessWidget {
  final List<List<int>> history;
  final List<Player> players;
  final Function(int) onEditRound;
  
  const GameHistoryPage({
    super.key, 
    required this.history, 
    required this.players,
    required this.onEditRound,
  });

  String _getAbbreviatedName(String name) {
    if (name.length <= 8) return name;
    return name.substring(0, 6) + '..';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spielverlauf')),
      body: SingleChildScrollView(
        child: DataTable(
          columnSpacing: 12,
          columns: [
            const DataColumn(label: Text('Runde', style: TextStyle(fontSize: 12))),
            ...players.map((p) => DataColumn(
              label: Text(_getAbbreviatedName(p.name), style: const TextStyle(fontSize: 12))
            )),
            const DataColumn(label: Text('', style: TextStyle(fontSize: 12))),
          ],
          rows: [
            // Current totals row
            DataRow(
              cells: [
                const DataCell(Text('Gesamt', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
                ...players.map((p) => DataCell(
                  Text('${p.score}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                )),
                const DataCell(Text('')),
              ],
            ),
            // Individual round rows
            ...history.asMap().entries.map((entry) {
              int roundIndex = entry.key;
              List<int> roundScores = entry.value;
              return DataRow(
                cells: [
                  DataCell(Text('${roundIndex + 1}', style: const TextStyle(fontSize: 12))),
                  ...roundScores.map((score) => DataCell(
                    Text('$score', style: const TextStyle(fontSize: 12))
                  )),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.edit, size: 14),
                      onPressed: () => onEditRound(roundIndex + 1),
                      tooltip: 'Runde bearbeiten',
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
} 