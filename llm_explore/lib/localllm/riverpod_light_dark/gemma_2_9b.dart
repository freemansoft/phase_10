import 'package:flutter/material.dart';
// Import your chosen table library, Riverpod, and other dependencies
import 'package:riverpod_annotation/riverpod_annotation.dart';
// Example for using riverpod

@immutable
class Player {
  final String name;
  final int totalScore;

  Player({required this.name, required this.totalScore});
}

// State Management with Riverpod (Example)
final playersProvider = Provider(
  (ref) => [
    Player(name: 'Player 1', totalScore: 0),
    Player(name: 'Player 2', totalScore: 0),
    // Add more players here
  ],
);

class Phase10Sandbox extends StatelessWidget {
  const Phase10Sandbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Sandbox',
      themeMode: ThemeMode.light, // Initial theme
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: const Scaffold(
        appBar: AppBar(
          title: const Text('Phase 10 Sandbox'),
          actions: [
            Switch(
              value:
                  ThemeMode
                      .light, // Current theme mode (update to use your state)
              onChanged: (bool value) {
                // Toggle theme when switch is changed (update with Riverpod logic)
              },
            ),
          ],
        ),
        body: const Phase10Table(),
      ),
    );
  }
}

class Phase10Table extends StatelessWidget {
  const Phase10Table({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        // Access players data using ref.watch(playersProvider)
        final players = ref.watch(playersProvider);

        return Scrollbar(
          // Add scrolling for the table
          child: Table(
            // ... your table structure here
          ),
        );
      },
    );
  }
}
