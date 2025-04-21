import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class Phase10Sandbox extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the Riverpod provider to access the state of the application
    final game = ref.watch(phase10GameStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Sandbox'),
        actions: [
          Switch(
            value: ref.watch(themeModeProvider),
            onChanged: (value) {
              // Update the theme mode when the switch is toggled
              ref.update(() => themeModeProvider = value);
            },
          ),
        ],
      ),
      body: ConsumerBuilder<GameState>(
        builder: (_, gameState, child) {
          return GridView.count(
            crossAxisCount: 2,
            children: List.generate(gameState.players.length, (index) {
              // Create a new row for each player
              return Row(
                children: [
                  // Display the player's name and total score in the first column
                  Column(
                    children: [
                      Text(gameState.players[index].name),
                      Text '${gameState.players[index].totalScore}'),
                    ],
                  ),
                  // Create a table to display the round scores for each player
                  DataTable2(
                    columns: List.generate(12, (index) {
                      return DataColumn2(
                        cells: [DataCell(Text('Round ${index + 1}'))],
                      );
                    }),
                    rows: List.generate(gameState.players[index].roundScores.length,
                          (index) {
                        return DataRow2(cells: [
                          DataCell(Text(gameState.players[index].roundScores[index].score.toString())),
                          DataCell(DropDownButton(
                            options: [DropDownMenuItem(value: '1'), DropDownMenuItem(value: '2'), ...],
                          )),
                        ]);
                      }),
                  ),
                ],
              );
            }),
          );
        },
      ),
    );
  }
}

class GameState {
  List<Player> players;
  int totalScore;

  // Add any other properties or methods as needed
}