import 'package:flutter/material.dart';
import '../models/enums.dart';
import '../models/player.dart';
import '../models/round_result.dart';

class RoundResultDialog extends StatefulWidget {
  const RoundResultDialog({
    super.key, 
    required this.onResultsApplied, 
    required this.players,
    this.roundToEdit,
    required this.currentRound,
  });

  final Function(Map<int, int>, Team, Solo, List<Announcement>, Map<int, List<GameEvent>>, int?) onResultsApplied;
  final List<Player> players;
  final int? roundToEdit;
  final int currentRound;

  @override
  State<RoundResultDialog> createState() => _RoundResultDialogState();
}

class _RoundResultDialogState extends State<RoundResultDialog> {
  Map<int, Team> playerTeams = {};
  Map<int, List<Announcement>> playerAnnouncements = {};
  List<GameEvent> reEvents = [];
  List<GameEvent> kontraEvents = [];
  List<GameEvent> soloistEvents = [];
  List<GameEvent> opponentsEvents = [];
  Team? winningTeam;
  Solo selectedSolo = Solo.none;
  int? soloistIndex;
  List<Announcement> teamAnnouncements = [];
  int? soloWinner; // 0 = soloist, 1 = opponents

  @override
  void initState() {
    super.initState();
    if (widget.roundToEdit != null) {
      final roundIndex = widget.roundToEdit! - 1;
      for (int i = 0; i < widget.players.length; i++) {
        final result = widget.players[i].roundResults[roundIndex];
        playerTeams[i] = result.team;
        if (selectedSolo == Solo.none) {
          if (result.team == Team.re) {
            reEvents = List.from(result.events);
          } else {
            kontraEvents = List.from(result.events);
          }
        } else {
          if (soloistIndex != null && i == soloistIndex) {
            soloistEvents = List.from(result.events);
          } else {
            opponentsEvents = List.from(result.events);
          }
        }
        if (i == 0) {
          teamAnnouncements = List.from(result.announcements);
          selectedSolo = result.solo;
          if (selectedSolo != Solo.none) {
            // Find soloist
            for (int j = 0; j < widget.players.length; j++) {
              if (result.team == Team.re) {
                soloistIndex = j;
                break;
              }
            }
            // Guess winner from points
            if (result.points > 0) {
              soloWinner = 0;
            } else {
              soloWinner = 1;
            }
          }
          winningTeam = result.points > 0 ? result.team : (result.team == Team.re ? Team.kontra : Team.re);
        }
      }
    }
  }

  void _updateTeamEvents(int playerIndex, Team team) {
    setState(() {
      playerTeams[playerIndex] = team;
      for (int i = 0; i < widget.players.length; i++) {
        if (playerTeams[i] == team && i != playerIndex) {
          if (selectedSolo == Solo.none) {
            if (i < 2) {
              reEvents = List.from(kontraEvents);
              kontraEvents = [];
            } else {
              kontraEvents = List.from(reEvents);
              reEvents = [];
            }
          } else {
            if (i == soloistIndex) {
              soloistEvents = List.from(opponentsEvents);
              opponentsEvents = [];
            } else {
              opponentsEvents = List.from(soloistEvents);
              soloistEvents = [];
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.roundToEdit != null 
        ? 'Runde ${widget.roundToEdit} bearbeiten'
        : 'Runde ${widget.currentRound} eintragen';
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.sports_esports),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Team Assignment (disabled if Solo)
                    if (selectedSolo == Solo.none) ...[
                      const Text(
                        'Teams zuordnen',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      for (int i = 0; i < 4; i++) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(widget.players[i].name),
                              ),
                              Expanded(
                                flex: 3,
                                child: ToggleButtons(
                                  isSelected: [
                                    playerTeams[i] == Team.re,
                                    playerTeams[i] == Team.kontra,
                                  ],
                                  onPressed: (index) {
                                    setState(() {
                                      _updateTeamEvents(i, index == 0 ? Team.re : Team.kontra);
                                    });
                                  },
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('Re'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Text('Kontra'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                    ],
                    // Solo Game Selection
                    const Text(
                      'Solo-Spiel',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: Solo.values.map((solo) {
                        return FilterChip(
                          label: Text(_getSoloText(solo)),
                          selected: selectedSolo == solo,
                          onSelected: (selected) {
                            setState(() {
                              selectedSolo = selected ? solo : Solo.none;
                              if (selectedSolo == Solo.none) soloistIndex = null;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    if (selectedSolo != Solo.none) ...[
                      const SizedBox(height: 12),
                      const Text('Solo-Spieler wählen:', style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<int>(
                        value: soloistIndex,
                        hint: const Text('Solo-Spieler wählen'),
                        items: List.generate(widget.players.length, (i) => DropdownMenuItem(
                          value: i,
                          child: Text(widget.players[i].name),
                        )),
                        onChanged: (value) {
                          setState(() {
                            soloistIndex = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Team Announcements
                    const Text(
                      'Ansagen',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: Announcement.values.where((a) => a != Announcement.none).map((announcement) {
                        return FilterChip(
                          label: Text(_getAnnouncementText(announcement)),
                          selected: teamAnnouncements.contains(announcement),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                teamAnnouncements.add(announcement);
                              } else {
                                teamAnnouncements.remove(announcement);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    // Game Events
                    const Text(
                      'Spielereignisse',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    if (selectedSolo == Solo.none) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Re-Team:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Re', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: GameEvent.values.map((event) {
                                return FilterChip(
                                  label: Text(_getEventText(event)),
                                  selected: reEvents.contains(event),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        reEvents.add(event);
                                      } else {
                                        reEvents.remove(event);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Kontra-Team:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Kontra', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: GameEvent.values.map((event) {
                                return FilterChip(
                                  label: Text(_getEventText(event)),
                                  selected: kontraEvents.contains(event),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        kontraEvents.add(event);
                                      } else {
                                        kontraEvents.remove(event);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ] else if (selectedSolo != Solo.none && soloistIndex != null) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text('${widget.players[soloistIndex!].name} (Solo-Spieler):', style: const TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Solo', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: GameEvent.values.map((event) {
                                return FilterChip(
                                  label: Text(_getEventText(event)),
                                  selected: soloistEvents.contains(event),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        soloistEvents.add(event);
                                      } else {
                                        soloistEvents.remove(event);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text('Gegenpartei:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text('Gegner', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 4,
                              runSpacing: 4,
                              children: GameEvent.values.map((event) {
                                return FilterChip(
                                  label: Text(_getEventText(event)),
                                  selected: opponentsEvents.contains(event),
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        opponentsEvents.add(event);
                                      } else {
                                        opponentsEvents.remove(event);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Winning Team (disabled if Solo)
                    if (selectedSolo == Solo.none) ...[
                      const Text(
                        'Gewinner',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: RadioListTile<Team>(
                              title: const Text('Re'),
                              value: Team.re,
                              groupValue: winningTeam,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              onChanged: (Team? value) {
                                setState(() {
                                  winningTeam = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<Team>(
                              title: const Text('Kontra'),
                              value: Team.kontra,
                              groupValue: winningTeam,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              onChanged: (Team? value) {
                                setState(() {
                                  winningTeam = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    // Winner Selection for Solo
                    if (selectedSolo != Solo.none && soloistIndex != null) ...[
                      const Text('Gewinner:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: RadioListTile<int>(
                              title: const Text('Solo'),
                              value: 0,
                              groupValue: soloWinner,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (int? value) {
                                setState(() {
                                  soloWinner = value;
                                });
                              },
                            ),
                          ),
                          Flexible(
                            child: RadioListTile<int>(
                              title: const Text('Gegner'),
                              value: 1,
                              groupValue: soloWinner,
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              onChanged: (int? value) {
                                setState(() {
                                  soloWinner = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    // Calculate Button
                    if ((selectedSolo == Solo.none && winningTeam != null && playerTeams.length == 4) ||
                        (selectedSolo != Solo.none && soloistIndex != null)) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _calculateAndShowResults,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            widget.roundToEdit != null ? 'Änderungen speichern' : 'Ergebnis berechnen', 
                            style: const TextStyle(fontSize: 16)
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAnnouncementText(Announcement announcement) {
    switch (announcement) {
      case Announcement.none:
        return 'Keine';
      case Announcement.keine90:
        return 'Keine 90';
      case Announcement.keine60:
        return 'Keine 60';
      case Announcement.keine30:
        return 'Keine 30';
      case Announcement.schwarz:
        return 'Schwarz';
      case Announcement.armut:
        return 'Armut';
    }
  }

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

  String _getSoloText(Solo solo) {
    switch (solo) {
      case Solo.none:
        return 'Kein Solo';
      case Solo.trumpfsolo:
        return 'Trumpfsolo';
      case Solo.farbsolo:
        return 'Farbsolo';
      case Solo.damensolo:
        return 'Damensolo';
      case Solo.bubensolo:
        return 'Bubensolo';
      case Solo.fleischloser:
        return 'Fleischloser';
      case Solo.hochzeit:
        return 'Hochzeit';
    }
  }

  void _calculateAndShowResults() {
    if ((selectedSolo == Solo.none && (winningTeam == null || playerTeams.length != 4)) ||
        (selectedSolo != Solo.none && (soloistIndex == null || soloWinner == null))) return;

    int basePoints = 1;
    int announcementBonus = 0;
    for (var announcement in teamAnnouncements) {
      announcementBonus += _getAnnouncementPoints(announcement);
    }
    int soloMultiplier = selectedSolo != Solo.none ? 2 : 1;
    Map<int, int> playerPoints = {};
    Map<int, List<GameEvent>> playerEvents = {};
    if (selectedSolo == Solo.none) {
      for (int i = 0; i < 4; i++) {
        int points = 0;
        if (playerTeams[i] == winningTeam) {
          points = (basePoints + announcementBonus) * soloMultiplier;
          playerEvents[i] = List.from(playerTeams[i] == Team.re ? reEvents : kontraEvents);
        } else {
          points = -(basePoints + announcementBonus) * soloMultiplier;
          playerEvents[i] = List.from(playerTeams[i] == Team.re ? reEvents : kontraEvents);
        }
        for (var event in playerEvents[i]!) {
          points += _getEventPoints(event);
        }
        playerPoints[i] = points;
      }
    } else {
      // Solo logic: soloist vs rest, winner can be soloist or opponents
      for (int i = 0; i < 4; i++) {
        int points = 0;
        if ((soloWinner == 0 && i == soloistIndex) || (soloWinner == 1 && i != soloistIndex)) {
          // Winner (soloist or opponents)
          points = (basePoints + announcementBonus) * soloMultiplier * (i == soloistIndex ? 3 : 1);
          playerEvents[i] = i == soloistIndex ? List.from(soloistEvents) : List.from(opponentsEvents);
        } else {
          // Loser (soloist or opponents)
          points = -((basePoints + announcementBonus) * soloMultiplier) * (i == soloistIndex ? 3 : 1);
          playerEvents[i] = i == soloistIndex ? List.from(soloistEvents) : List.from(opponentsEvents);
        }
        for (var event in playerEvents[i]!) {
          points += _getEventPoints(event);
        }
        playerPoints[i] = points;
      }
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Runden-Ergebnis'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedSolo == Solo.none) ...[
                  Row(
                    children: [
                      const Text('Gewinner: '),
                      Text(
                        winningTeam == Team.re ? 'Re' : 'Kontra',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      const Text('Solo-Spieler: '),
                      Text(
                        widget.players[soloistIndex!].name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Solo-Art: ${_getSoloText(selectedSolo)}'),
                ],
                if (teamAnnouncements.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Ansagen: ${teamAnnouncements.map((a) => _getAnnouncementText(a)).join(", ")}'),
                ],
                const SizedBox(height: 16),
                ...playerPoints.entries.map((entry) => 
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(widget.players[entry.key].name),
                            ),
                            Text(
                              '${entry.value > 0 ? "+" : ""}${entry.value}',
                              style: TextStyle(
                                color: entry.value >= 0 ? Colors.green[700] : Colors.red[700],
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        if (playerEvents[entry.key]?.isNotEmpty ?? false) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Ereignisse: ${playerEvents[entry.key]!.map((e) => _getEventText(e)).join(", ")}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Abbrechen'),
            ),
            TextButton(
              onPressed: () {
                // Apply results to players
                widget.onResultsApplied(playerPoints, selectedSolo == Solo.none ? (winningTeam ?? Team.re) : Team.re, selectedSolo, teamAnnouncements, playerEvents, widget.roundToEdit);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Übernehmen'),
            ),
          ],
        );
      },
    );
  }

  int _getAnnouncementPoints(Announcement announcement) {
    switch (announcement) {
      case Announcement.none:
        return 0;
      case Announcement.keine90:
        return 1;
      case Announcement.keine60:
        return 2;
      case Announcement.keine30:
        return 3;
      case Announcement.schwarz:
        return 4;
      case Announcement.armut:
        return 5;
    }
  }

  int _getEventPoints(GameEvent event) {
    switch (event) {
      case GameEvent.fox:
        return 1;
      case GameEvent.karlchen:
        return 1;
      case GameEvent.doppelkopf:
        return 1;
    }
  }
} 