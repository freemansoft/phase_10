import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:phase_10_app/player_name_field.dart';
import 'package:phase_10_app/round_score_field.dart';
import 'package:phase_10_app/provider/players_provider.dart';

class ScoreTable extends ConsumerStatefulWidget {
  const ScoreTable({super.key});

  @override
  ConsumerState<ScoreTable> createState() => _ScoreTableState();
}

// ...existing code...
class _ScoreTableState extends ConsumerState<ScoreTable> {
  // Removed: final Map<int, TextEditingController> _nameControllers = {};

  @override
  void dispose() {
    // Removed: for (final controller in _nameControllers.values) { controller.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);

    // Removed: name controller sync logic

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1200,
      fixedLeftColumns: 1,
      fixedTopRows: 1,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      dataRowHeight: 74,
      border: TableBorder.all(
        color: Theme.of(context).colorScheme.outline.withAlpha(100),
        width: 1,
      ),
      columns: [
        const DataColumn2(
          label: Text('Player/Total'),
          size: ColumnSize.L,
          fixedWidth: 80,
        ),
        ...List.generate(
          12,
          (round) => DataColumn2(
            label: Text('Round ${round + 1}'),
            size: ColumnSize.S,
            headingRowAlignment: MainAxisAlignment.center,
          ),
        ),
      ],
      rows: List<DataRow2>.generate(players.length, (playerIdx) {
        final player = players[playerIdx];
        final isEven = playerIdx % 2 == 0;

        return DataRow2(
          color: WidgetStateProperty.resolveWith<Color?>((
            Set<WidgetState> states,
          ) {
            final colorScheme = Theme.of(context).colorScheme;
            return isEven
                ? colorScheme.primary.withAlpha(60)
                : colorScheme.tertiary.withAlpha(60);
          }),
          cells: [
            DataCell(
              SizedBox(
                width: 120,
                child: Column(
                  children: [
                    PlayerNameField(
                      key: ValueKey('player_name_field_$playerIdx'),
                      name: player.name,
                      onChanged: (val) {
                        ref
                            .read(playersProvider.notifier)
                            .updatePlayerName(playerIdx, val);
                      },
                    ),
                    Text(
                      '${player.totalScore}',
                      key: ValueKey(
                        'player_total_score_$playerIdx',
                      ), // Unique key for total score
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            ...List<DataCell>.generate(12, (round) {
              final phase = player.phases.getPhase(round);
              final score = player.scores.getScore(round);
              return DataCell(
                SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int?>(
                        key: ValueKey(
                          'phase_dropdown_p${playerIdx}_r$round',
                        ), // Unique key for phase dropdown
                        value: phase,
                        isExpanded: true,
                        hint: const Text('Phase'),
                        items: [
                          const DropdownMenuItem<int?>(
                            value: null,
                            child: Text('None'),
                          ),
                          ...List.generate(
                            10,
                            (i) => DropdownMenuItem<int?>(
                              value: i + 1,
                              child: Text('${i + 1}'),
                            ),
                          ),
                        ],
                        onChanged: (val) {
                          ref
                              .read(playersProvider.notifier)
                              .updatePhase(playerIdx, round, val);

                          // Show a 10 second alert with all completed phases
                          final completedPhases =
                              player.phases.completedPhasesList();
                          if (completedPhases.isNotEmpty) {
                            final snackBar = SnackBar(
                              content: Text(
                                '${player.name}: ${completedPhases.join(', ')}',
                              ),
                              duration: const Duration(seconds: 3),
                            );
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(snackBar);
                          }
                        },
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                      RoundScoreField(
                        key: ValueKey(
                          'round_score_p${playerIdx}_r$round',
                        ), // Unique key for round score field
                        score: score,
                        onChanged: (parsed) {
                          ref
                              .read(playersProvider.notifier)
                              .updateScore(playerIdx, round, parsed);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );
      }),
    );
  }
}
// ...existing code...