import 'package:flutter/material.dart';
import 'package:flutter_riverpod.dart';
import 'package:flutter_table/flutter_table.dart';

// Define player data structure
class Player {
  final int id;
  final String name;
  final List<int> scores;

  Player({
    required this.id,
    required this.name,
    required this.scores,
  });
}

// State management setup
final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>> (
  (ref) => PlayersNotifier(),
);

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier() : super([]);

  void addPlayer(String name) {
    final player = Player(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      scores: List<int>.filled(12, 0),
    );
    state = [...state, player];
  }

  // Update player name
  void updatePlayerName(int playerId, String newName) {
    final updatedPlayers = state.map((player) {
      if (player.id == playerId) {
        return Player(
          id: player.id,
          name: newName,
          scores: player.scores.toList(),
        );
      }
      return player;
    }).toList();
    state = updatedPlayers;
  }

  // Update round score
  void updateRoundScore(int playerId, int roundIndex, int newScore) {
    final updatedPlayers = state.map((player) {
      if (player.id == playerId) {
        final List<int> newScores = player.scores.toList();
        newScores[roundIndex] = newScore;
        return Player(
          id: player.id,
          name: player.name,
          scores: newScores,
        );
      }
      return player;
    }).toList();
    state = updatedPlayers;
  }

  // Calculate total score
  int calculateTotalScore(List<int> roundScores) {
    return roundScores.reduce((a, b) => a + b);
  }
}

// Main application widget
class Phase10Scorer extends StatelessWidget {
  const Phase10Scorer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = MediaQuery.of(context).prefers Brightness.dark;

    return MaterialApp(
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Phase 10 Scorer'),
          actions: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.brightness_low : Icons.brightness_high),
              onPressed: () {
                Theme.of(context).toggleBrightness();
              },
            ),
          ],
        ),
        body: _buildScoreTable(),
      ),
    );
  }

  Widget _buildScoreTable() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: FlutterDataTable(
          columns: [
            DataColumn(
              label: Text('Player'),
            ),
            ...List.generate(12, (index) => DataColumn(label: Text('Round ${index + 1}'))),
          ],
          rows: List<Player>.from(stateNotifierScope(playersProvider).state).map((player) {
            return DataRow(
              cells: [
                DataCell(
                  Column(
                    children: [
                      Text(player.name),
                      const SizedBox(height: 4),
                      Text('Total: ${Player.calculateTotalScore(player.scores)}'),
                    ],
                  ),
                ),
                ...List.generate(12, (roundIndex) {
                  return DataCell(
                    Column(
                      children: [
                        TextField(
                          controller: TextEditingController(),
                          onChanged: (value) {
                            // Update score
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Score'),
                        ),
                        DropdownButton<String>(
                          items: [''] + List.generate(10, (i) => i.toString()),
                          value: '',
                          onChanged: (String? value) {
                            // Handle phase selection
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Add this to your pubspec.yaml:
// dependencies:
//   flutter_table: ^2.0.0