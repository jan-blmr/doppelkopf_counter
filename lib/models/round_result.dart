import 'enums.dart';

class RoundResult {
  final int points;
  final Team team;
  final Solo solo;
  final List<Announcement> announcements;
  final List<GameEvent> events;
  final String description;

  RoundResult({
    required this.points,
    required this.team,
    this.solo = Solo.none,
    this.announcements = const [],
    this.events = const [],
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'points': points,
    'team': team.toShortString(),
    'solo': solo.toShortString(),
    'announcements': announcements.map((a) => a.toShortString()).toList(),
    'events': events.map((e) => e.toShortString()).toList(),
    'description': description,
  };

  static RoundResult fromJson(Map<String, dynamic> json) => RoundResult(
    points: json['points'],
    team: TeamExt.fromString(json['team']),
    solo: SoloExt.fromString(json['solo']),
    announcements: (json['announcements'] as List).map((a) => AnnouncementExt.fromString(a)).toList(),
    events: (json['events'] as List).map((e) => GameEventExt.fromString(e)).toList(),
    description: json['description'],
  );
} 