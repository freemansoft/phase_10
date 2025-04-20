import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

// Define a Provider to manage the score data
final scoresProvider = Provider<List<Score>>((ref) {
  return []; // Initially, there are no scores
});

class Score {
  final String name;
  final int totalPoints;
  final List<Round> rounds;

  Score(this.name, this.totalPoints, this.rounds);
}

class Round {
  final int points;
  final Phase phaseCompleted;

  Round(this.points, this.phaseCompleted);
}

enum Phase {
  NONE,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10
}

class ScorekeeperPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scorekeeper'),
      ),
      body: Center(
        child: Column(
          children: [
            // Display the score data using a data_table widget
            ScoreDataTable(),

            // Provide a way to switch between light and dark mode
            Switch(
              value: Theme.of(context).brightness == Brightness.dark,
              onChanged: (value) {
                ThemeService.updateBrightness(
                  context,
                  value ? Brightness.dark : Brightness.light,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Define a widget to display the score data using a data_table widget
class ScoreDataTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the scores from the Provider
    final List<Score> scores = useProvider(scoresProvider);

    return DataTable(
      columns: [
        // First column shows the total score for each player
        DataColumn(
          label: Text('Total'),
          numeric: true,
        ),

        // Next 12 columns show the individual round scores and phases completed
        ...List.generate(12, (index) {
          return DataColumn(
            label: Text('Round $index'),
            numeric: true,
          );
        }),
      ],
      rows: List.generate(scores.length, (index) {
        final score = scores[index];

        // Build the row for each player
        return DataRow(
          cells: [
            // Total score field
            DataCell(Text('${score.totalPoints}')),

            // Individual round fields
            ...List.generate(12, (roundIndex) {
              final round = score.rounds[roundIndex];
              return DataCell(
                Text('$round'),
                onTap: () {
                  // TODO: Implement editing of the individual round scores and phases
                },
              );
            }),
          ],
        );
      }),
    );
  }
}