import 'round_result.dart';
import 'enums.dart';

class Player {
  String name;
  int score;
  List<RoundResult> roundResults;
  Team? currentTeam;
  List<GameEvent> currentEvents;

  Player({required this.name, this.score = 0, List<RoundResult>? roundResults})
      : roundResults = roundResults ?? [],
        currentEvents = [];

  void addRoundResult(RoundResult result) {
    score += result.points;
    roundResults.add(result);
  }

  void resetScore() {
    score = 0;
    roundResults.clear();
  }

  void recalculateScore() {
    score = 0;
    for (var result in roundResults) {
      score += result.points;
    }
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'score': score,
    'roundResults': roundResults.map((r) => r.toJson()).toList(),
    'currentTeam': currentTeam?.toShortString(),
    'currentEvents': currentEvents.map((e) => e.toShortString()).toList(),
  };

  static Player fromJson(Map<String, dynamic> json) => Player(
    name: json['name'],
    score: json['score'],
    roundResults: (json['roundResults'] as List).map((r) => RoundResult.fromJson(r)).toList(),
  )
    ..currentTeam = json['currentTeam'] != null ? TeamExt.fromString(json['currentTeam']) : null
    ..currentEvents = (json['currentEvents'] as List).map((e) => GameEventExt.fromString(e)).toList();
} 