enum Team { re, kontra }
enum Solo { none, trumpfsolo, farbsolo, damensolo, bubensolo, fleischloser, hochzeit }
enum Announcement { none, keine90, keine60, keine30, schwarz, armut }
enum GameEvent { fox, karlchen, doppelkopf }

// --- Enum helpers for serialization ---
extension TeamExt on Team {
  String toShortString() => toString().split('.').last;
  static Team fromString(String s) => Team.values.firstWhere((e) => e.toString().split('.').last == s);
}
extension SoloExt on Solo {
  String toShortString() => toString().split('.').last;
  static Solo fromString(String s) => Solo.values.firstWhere((e) => e.toString().split('.').last == s);
}
extension AnnouncementExt on Announcement {
  String toShortString() => toString().split('.').last;
  static Announcement fromString(String s) => Announcement.values.firstWhere((e) => e.toString().split('.').last == s);
}
extension GameEventExt on GameEvent {
  String toShortString() => toString().split('.').last;
  static GameEvent fromString(String s) => GameEvent.values.firstWhere((e) => e.toString().split('.').last == s);
} 