import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';

void main() {
  runApp(const ProviderScope(child: Phase10App()));
}

// Model classes
class PlayerScore {
  final String id;
  String name;
  List<int?> scores;
  List<int?> phases;

  PlayerScore({
    required this.id,
    required this.name,
    required this.scores,
    required this.phases,
  });

  int get total => scores
      .where((score) => score != null)
      .fold(0, (sum, score) => sum + (score ?? 0));

  PlayerScore copyWith({String? name, List<int?>? scores, List<int?>? phases}) {
    return PlayerScore(
      id: id,
      name: name ?? this.name,
      scores: scores ?? this.scores,
      phases: phases ?? this.phases,
    );
  }
}

// State management
class GameState extends StateNotifier<List<PlayerScore>> {
  GameState()
    : super(
        List.generate(
          8,
          (index) => PlayerScore(
            id: 'player_$index',
            name: 'Player ${index + 1}',
            scores: List.filled(12, null),
            phases: List.filled(12, null),
          ),
        ),
      );

  void updatePlayerName(String playerId, String newName) {
    state = [
      for (final player in state)
        if (player.id == playerId) player.copyWith(name: newName) else player,
    ];
  }

  void updateScore(String playerId, int roundIndex, int? score) {
    state = [
      for (final player in state)
        if (player.id == playerId)
          player.copyWith(
            scores: [
              for (int i = 0; i < player.scores.length; i++)
                i == roundIndex ? score : player.scores[i],
            ],
          )
        else
          player,
    ];
  }

  void updatePhase(String playerId, int roundIndex, int? phase) {
    state = [
      for (final player in state)
        if (player.id == playerId)
          player.copyWith(
            phases: [
              for (int i = 0; i < player.phases.length; i++)
                i == roundIndex ? phase : player.phases[i],
            ],
          )
        else
          player,
    ];
  }
}

// Providers
final gameStateProvider = StateNotifierProvider<GameState, List<PlayerScore>>(
  (ref) => GameState(),
);
final themeProvider = StateProvider<bool>((ref) => false);

class Phase10App extends ConsumerWidget {
  const Phase10App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: const ScoreboardScreen(),
    );
  }
}

class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(gameStateProvider);
    final isDarkMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Scorekeeper'),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged:
                (value) => ref.read(themeProvider.notifier).state = value,
          ),
        ],
      ),
      body: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 1200,
        fixedLeftColumns: 2,
        columns: [
          const DataColumn2(label: Text('Player Name'), size: ColumnSize.S),
          const DataColumn2(label: Text('Total'), size: ColumnSize.S),
          for (int i = 1; i <= 12; i++)
            DataColumn2(label: Text('Round $i'), size: ColumnSize.L),
        ],
        rows:
            players.map((player) {
              return DataRow2(
                cells: [
                  DataCell(
                    TextField(
                      controller: TextEditingController(text: player.name),
                      onSubmitted:
                          (value) => ref
                              .read(gameStateProvider.notifier)
                              .updatePlayerName(player.id, value),
                    ),
                  ),
                  DataCell(Text(player.total.toString())),
                  for (int i = 0; i < 12; i++)
                    DataCell(
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                            controller: TextEditingController(
                              text: player.scores[i]?.toString() ?? '',
                            ),
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: 'Score',
                              isDense: true,
                            ),
                            onSubmitted:
                                (value) => ref
                                    .read(gameStateProvider.notifier)
                                    .updateScore(
                                      player.id,
                                      i,
                                      int.tryParse(value),
                                    ),
                          ),
                          DropdownButton<int?>(
                            value: player.phases[i],
                            hint: const Text('Phase'),
                            isDense: true,
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text(''),
                              ),
                              for (int phase = 1; phase <= 10; phase++)
                                DropdownMenuItem(
                                  value: phase,
                                  child: Text(phase.toString()),
                                ),
                            ],
                            onChanged:
                                (value) => ref
                                    .read(gameStateProvider.notifier)
                                    .updatePhase(player.id, i, value),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }
}
