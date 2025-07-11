import 'package:flutter/material.dart';
import '../utils/storage.dart';
import '../models/enums.dart';
import '../models/player.dart';
import '../models/round_result.dart';
import 'round_result_dialog.dart';
import 'rules_page.dart';
import 'game_history_page.dart';
import 'past_games_page.dart';
import '../widgets/player_card.dart';

class DoppelkopfHomePage extends StatefulWidget {
  const DoppelkopfHomePage({super.key});

  @override
  State<DoppelkopfHomePage> createState() => _DoppelkopfHomePageState();
}

class _DoppelkopfHomePageState extends State<DoppelkopfHomePage> {
  List<Player> players = [
    Player(name: 'Spieler 1'),
    Player(name: 'Spieler 2'),
    Player(name: 'Spieler 3'),
    Player(name: 'Spieler 4'),
  ];

  int currentRound = 1;
  bool gameInProgress = false;
  List<List<int>> gameHistory = [];
  List<Map<String, dynamic>> lastGames = [];
  int? loadedGameIndex;

  @override
  void initState() {
    super.initState();
    _loadGameState();
  }

  Future<void> _saveGameState() async {
    await saveGameState(
      players: players,
      gameHistory: gameHistory,
      currentRound: currentRound,
      gameInProgress: gameInProgress,
    );
  }

  Future<void> _loadGameState() async {
    final state = await loadGameState();
    List<Player> loadedPlayers = List<Player>.from(state['players'] ?? []);
    if (loadedPlayers.isEmpty) {
      loadedPlayers = [
        Player(name: 'Spieler 1'),
        Player(name: 'Spieler 2'),
        Player(name: 'Spieler 3'),
        Player(name: 'Spieler 4'),
      ];
    }
    setState(() {
      players = loadedPlayers;
      gameHistory = List<List<int>>.from(state['gameHistory'] ?? []);
      currentRound = state['currentRound'] ?? 1;
      gameInProgress = state['gameInProgress'] ?? false;
      lastGames = List<Map<String, dynamic>>.from(state['lastGames'] ?? []);
    });
  }

  void _loadLastGame(int index) {
    final game = lastGames[index];
    setState(() {
      players = (game['players'] as List).map((p) => Player.fromJson(p)).toList();
      gameHistory = (game['gameHistory'] as List).map<List<int>>((l) => List<int>.from(l)).toList();
      currentRound = game['currentRound'];
      gameInProgress = game['gameInProgress'];
      loadedGameIndex = index;
    });
  }

  void _startNewGame() {
    setState(() {
      for (var player in players) {
        player.resetScore();
        player.currentTeam = null;
      }
      currentRound = 1;
      gameInProgress = true;
      gameHistory.clear();
      loadedGameIndex = null;
    });
    _saveGameState();
  }

  void _editPlayerName(int playerIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String defaultName = 'Spieler  {playerIndex + 1}';
        String newName = players[playerIndex].name == defaultName ? '' : players[playerIndex].name;
        return AlertDialog(
          title: const Text('Spielername bearbeiten'),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Spielername',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: newName),
            onChanged: (value) {
              newName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  players[playerIndex].name = newName.isEmpty ? defaultName : newName;
                });
                _saveGameState();
                Navigator.of(context).pop();
              },
              child: const Text('Speichern'),
            ),
          ],
        );
      },
    );
  }

  void _showRoundDialog([int? roundToEdit]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return RoundResultDialog(
          onResultsApplied: _applyRoundResults,
          players: players,
          roundToEdit: roundToEdit,
          currentRound: currentRound,
        );
      },
    );
  }

  void _applyRoundResults(Map<int, int> playerPoints, Team winningTeam, Solo solo, List<Announcement> announcements, Map<int, List<GameEvent>> playerEvents, [int? roundToEdit]) {
    setState(() {
      List<int> roundScores = [];
      if (roundToEdit != null) {
        for (int i = 0; i < players.length; i++) {
          players[i].roundResults.removeAt(roundToEdit - 1);
        }
        gameHistory.removeAt(roundToEdit - 1);
      }
      for (int i = 0; i < players.length; i++) {
        if (playerPoints.containsKey(i)) {
          final points = playerPoints[i]!;
          final team = points > 0 ? winningTeam : (winningTeam == Team.re ? Team.kontra : Team.re);
          final events = playerEvents[i] ?? [];
          players[i].currentTeam = team;
          players[i].currentEvents = events;
          final roundNumber = roundToEdit ?? currentRound;
          players[i].addRoundResult(RoundResult(
            points: points,
            team: team,
            solo: solo,
            announcements: announcements,
            events: events,
            description: 'Runde $roundNumber - ${team == Team.re ? "Re" : "Kontra"} ${points > 0 ? "gewonnen" : "verloren"}',
          ));
          roundScores.add(points);
        }
      }
      if (roundToEdit != null) {
        gameHistory.insert(roundToEdit - 1, roundScores);
        for (var player in players) {
          player.recalculateScore();
        }
      } else {
        gameHistory.add(roundScores);
        currentRound++;
      }
      _saveGameState();
    });
  }

  void _showRulesPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RulesPage()),
    );
  }

  void _showGameHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => GameHistoryPage(
        history: gameHistory,
        players: players,
        onEditRound: _showRoundDialog,
      )),
    );
  }

  void _finishGame() async {
    setState(() {
      gameInProgress = false;
    });
    await _saveGameState();
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Spiel beendet'),
          content: const Text('Das Spiel wurde gespeichert. Möchtest du ein neues Spiel starten?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Nein'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNewGame();
              },
              child: const Text('Neues Spiel'),
            ),
          ],
        ),
      );
    }
  }

  void _showPastGamesPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PastGamesPage(
        lastGames: lastGames,
        onSelect: (index) {
          _loadLastGame(index);
          Navigator.of(context).pop();
        },
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/logo_trans.png',
          height: 32,
          fit: BoxFit.contain,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Vergangene Spiele',
            onPressed: () => _showPastGamesPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Regeln',
            onPressed: () => _showRulesPage(context),
          ),
          IconButton(
            icon: const Icon(Icons.table_chart),
            tooltip: 'Spielverlauf',
            onPressed: () => _showGameHistory(context),
          ),
          if (gameInProgress)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _startNewGame,
              tooltip: 'Neues Spiel',
            ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceVariant,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Runde: $currentRound',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (gameInProgress)
                  ElevatedButton(
                    onPressed: () => _showRoundDialog(),
                    child: const Text('Runde eintragen'),
                  ),
              ],
            ),
          ),
          if (gameInProgress)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.flag),
                  label: const Text('Spiel beenden'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: _finishGame,
                ),
              ),
            ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: players.length,
              itemBuilder: (context, index) {
                return PlayerCard(
                  player: players[index],
                  onEdit: () => _editPlayerName(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: !gameInProgress
          ? FloatingActionButton.extended(
              onPressed: _startNewGame,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Spiel starten'),
            )
          : null,
    );
  }
} 