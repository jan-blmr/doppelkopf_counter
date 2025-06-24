import 'package:flutter/material.dart';

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doppelkopf Regeln')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Doppelkopf - Vollständige Regeln',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Grundlagen',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Doppelkopf ist ein traditionelles deutsches Kartenspiel für 4 Spieler. Es wird mit zwei Skatblättern (48 Karten) gespielt. Das Spiel basiert auf dem Prinzip von Re und Kontra - zwei Teams, die gegeneinander antreten.',
            ),
            SizedBox(height: 16),
            Text(
              'Karten und Werte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Trumpf: Alle Damen, alle Buben, alle Karo-Asse, alle Karo-10, alle Karo-Könige, alle Karo-9, alle Karo-8, alle Karo-7\n'
              '• Pik-Asse: Höchste Trümpfe\n'
              '• Karo-Asse: Zweithöchste Trümpfe\n'
              '• Damen: Dritthöchste Trümpfe\n'
              '• Buben: Viertthöchste Trümpfe\n'
              '• Karo-10, Karo-König, Karo-9, Karo-8, Karo-7: Weitere Trümpfe in dieser Reihenfolge\n'
              '• Alle anderen Karten: Farben (Pik, Herz, Kreuz) mit normalen Werten',
            ),
            SizedBox(height: 16),
            Text(
              'Team-Bildung',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Re: Spieler mit den Kreuz-Damen (höchste Dame)\n'
              '• Kontra: Alle anderen Spieler\n'
              '• Die Teams werden erst nach dem ersten Stich bekannt, wenn die Kreuz-Dame gespielt wird',
            ),
            SizedBox(height: 16),
            Text(
              'Spielablauf',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '1. Jeder Spieler erhält 12 Karten\n'
              '2. Der Spieler links vom Geber spielt die erste Karte\n'
              '3. Die anderen Spieler müssen in der gleichen Farbe spielen (Farbzwang)\n'
              '4. Wer die höchste Karte spielt, gewinnt den Stich\n'
              '5. Der Gewinner spielt die nächste Karte\n'
              '6. Nach 12 Stichen endet die Runde',
            ),
            SizedBox(height: 16),
            Text(
              'Grundpunkte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Gewinner bekommen 1 Punkt\n'
              '• Verlierer verlieren 1 Punkt\n'
              '• Bei Gleichstand (120:120) gibt es 0 Punkte',
            ),
            SizedBox(height: 16),
            Text(
              'Ansagen (zusätzliche Punkte)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Keine 90: +1 Punkt (Team erreicht nicht 90 Augen)\n'
              '• Keine 60: +2 Punkte (Team erreicht nicht 60 Augen)\n'
              '• Keine 30: +3 Punkte (Team erreicht nicht 30 Augen)\n'
              '• Schwarz: +4 Punkte (Gegner gewinnt keinen Stich)\n'
              '• Armut: +5 Punkte (Team gewinnt nur Stiche mit Trümpfen)',
            ),
            SizedBox(height: 16),
            Text(
              'Spielereignisse (zusätzliche Punkte)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Fuchs (Kreuz-Bube): +1 Punkt für den Spieler, der ihn gewinnt\n'
              '• Karlchen (Pik-Dame): +1 Punkt für den Spieler, der sie gewinnt\n'
              '• Doppelkopf: +1 Punkt für das Team, das beide gleichen Karten gewinnt',
            ),
            SizedBox(height: 16),
            Text(
              'Solo-Spiele',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Trumpfsolo: Spieler spielt allein gegen die anderen drei\n'
              '• Farbsolo: Spieler spielt allein, eine bestimmte Farbe wird Trumpf\n'
              '• Damensolo: Spieler spielt allein, nur Damen sind Trumpf\n'
              '• Bubensolo: Spieler spielt allein, nur Buben sind Trumpf\n'
              '• Fleischloser: Spieler spielt allein, keine Trümpfe\n'
              '• Hochzeit: Spieler spielt allein, spezielle Regeln',
            ),
            SizedBox(height: 16),
            Text(
              'Solo-Punkte',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Solo-Spieler: 3-fache Punkte (gewinnen oder verlieren)\n'
              '• Gegenpartei: Normale Punkte\n'
              '• Bei Solo-Spielen können auch Ansagen gemacht werden',
            ),
            SizedBox(height: 16),
            Text(
              'Besondere Regeln',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Farbzwang: Muss in der ausgespielten Farbe spielen\n'
              '• Trumpfzwang: Wenn keine Farbe vorhanden, muss Trumpf gespielt werden\n'
              '• Stichzwang: Muss eine Karte spielen, die den Stich gewinnen kann\n'
              '• Schweinchen: Kreuz-Bube und Pik-Dame im gleichen Team = +1 Punkt',
            ),
            SizedBox(height: 16),
            Text(
              'Strategie-Tipps',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Beobachte, welche Karten bereits gespielt wurden\n'
              '• Versuche, deine Partner zu erkennen\n'
              '• Spiele starke Trümpfe früh, um Stiche zu gewinnen\n'
              '• Bewahre schwache Trümpfe für später auf\n'
              '• Kommuniziere mit deinem Partner durch dein Spiel\n'
              '• Bei Solo-Spielen: Konzentriere dich auf deine Stärken',
            ),
            SizedBox(height: 16),
            Text(
              'Spielziel',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Das Team, das die meisten Punkte sammelt, gewinnt die Runde. Das Spiel endet, wenn ein Team eine vorher vereinbarte Punktzahl erreicht (z.B. 50 Punkte).',
            ),
            SizedBox(height: 16),
            Text(
              'Variationen',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '• Regionale Unterschiede in den Regeln möglich\n'
              '• Verschiedene Ansagen-Regeln\n'
              '• Unterschiedliche Solo-Varianten\n'
              '• Verschiedene Punktesysteme',
            ),
            SizedBox(height: 32),
            Text(
              'Viel Spaß beim Spielen!',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 