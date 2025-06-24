import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const DoppelkopfApp());
}

class DoppelkopfApp extends StatelessWidget {
  const DoppelkopfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doppelkopf Zähler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E7D32),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const DoppelkopfHomePage(),
    );
  }
}
