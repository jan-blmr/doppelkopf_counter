import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/enums.dart';

class PlayerCard extends StatelessWidget {
  final Player player;
  final VoidCallback onEdit;

  const PlayerCard({super.key, required this.player, required this.onEdit});

  String _getEventText(GameEvent event) {
    switch (event) {
      case GameEvent.fox:
        return 'Fuchs';
      case GameEvent.karlchen:
        return 'Karlchen';
      case GameEvent.doppelkopf:
        return 'Doppelkopf';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onEdit,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      player.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: onEdit,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                '${player.score}',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: player.score >= 0 ? Colors.green[700] : Colors.red[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Punkte gesamt',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
              ),
              const SizedBox(height: 8),
              if (player.currentTeam != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: player.currentTeam == Team.re 
                        ? Colors.blue[100] 
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    player.currentTeam == Team.re ? 'Re' : 'Kontra',
                    style: TextStyle(
                      color: player.currentTeam == Team.re 
                          ? Colors.blue[800] 
                          : Colors.red[800],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              if (player.currentEvents.isNotEmpty) ...[
                Wrap(
                  spacing: 1,
                  runSpacing: 1,
                  children: player.currentEvents.map((event) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        _getEventText(event),
                        style: TextStyle(
                          color: Colors.orange[800],
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 4),
              ],
              if (player.roundResults.isNotEmpty) ...[
                Text(
                  'Letzte: ${player.roundResults.last.points}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 