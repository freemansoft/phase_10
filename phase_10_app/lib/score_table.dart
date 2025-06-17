import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:phase_10_app/player_name_field.dart';
import 'package:phase_10_app/round_score_field.dart';
import 'package:phase_10_app/provider/players_provider.dart';
import 'package:phase_10_app/phase_checkbox_dropdown.dart';
import 'package:phase_10_app/provider/game_provider.dart';
import 'package:phase_10_app/total_score_field.dart';

class ScoreTable extends ConsumerStatefulWidget {
  const ScoreTable({super.key});

  @override
  ConsumerState<ScoreTable> createState() => _ScoreTableState();
}

class _ScoreTableState extends ConsumerState<ScoreTable> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    final game = ref.watch(gameProvider);
    final minWidth = 100 + game.maxRounds * 100;

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: minWidth.toDouble(),
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
          game.maxRounds,
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
                    TotalScoreField(
                      totalScore: player.totalScore,
                      fieldKey: ValueKey('player_total_score_$playerIdx'),
                    ),
                  ],
                ),
              ),
            ),
            ...List<DataCell>.generate(game.maxRounds, (round) {
              final score = player.scores.getScore(round);
              return DataCell(
                SizedBox(
                  width: 90,
                  child: Column(
                    children: [
                      const SizedBox(height: 4),
                      PhaseCheckboxDropdown(
                        fieldKey: ValueKey(
                          'phase_checkbox_dropdown_p${playerIdx}_r$round',
                        ),
                        selectedPhase: player.phases.getPhase(round),
                        onChanged: (val) {
                          ref
                              .read(playersProvider.notifier)
                              .updatePhase(playerIdx, round, val);
                        },
                        playerIdx: playerIdx,
                        round: round,
                        completedPhases: player.phases.completedPhasesList(),
                      ),
                      const SizedBox(height: 4),
                      RoundScoreField(
                        key: ValueKey('round_score_p${playerIdx}_r$round'),
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
