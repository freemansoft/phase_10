import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';
import 'players_provider.dart';

class ScoreTable extends ConsumerWidget {
  const ScoreTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);

    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 1200,
      fixedLeftColumns: 1,
      fixedTopRows: 1,
      isHorizontalScrollBarVisible: true,
      isVerticalScrollBarVisible: true,
      dataRowHeight: 74,
      columns: [
        const DataColumn2(
          label: Text('Player / Total'),
          size: ColumnSize.L,
          fixedWidth: 100,
        ),
        ...List.generate(
          12,
          (round) => DataColumn2(
            label: Text('Round ${round + 1}'),
            size: ColumnSize.S,
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
            return isEven
                ? Colors.red.withAlpha(20)
                : Colors.blue.withAlpha(20);
          }),
          cells: [
            DataCell(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: TextFormField(
                      initialValue: player.name,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      onChanged: (val) {
                        ref
                            .read(playersProvider.notifier)
                            .updatePlayerName(playerIdx, val);
                      },
                    ),
                  ),
                  Container(
                    width: 120,
                    margin: const EdgeInsets.only(top: 1),
                    padding: const EdgeInsets.symmetric(
                      vertical: 2,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${player.totalScore}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
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
                              duration: const Duration(seconds: 5),
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
                          border:
                              OutlineInputBorder(), // <-- Add outline border here
                        ),
                      ),
                      TextFormField(
                        initialValue: score?.toString() ?? '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Score',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 8,
                          ),
                          border: OutlineInputBorder(), // <-- Add this line
                        ),
                        onChanged: (val) {
                          final parsed = int.tryParse(val);
                          ref
                              .read(playersProvider.notifier)
                              .updateScore(playerIdx, round, parsed);
                        },
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        // this adds a character counter
                        // maxLength: 4,
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
