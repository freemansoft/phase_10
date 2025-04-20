import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';

void main() {
  runApp(const ProviderScope(child: Phase10App()));
}

class Phase10App extends StatelessWidget {
  const Phase10App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ScoreKeeperScreen(),
    );
  }
}

class ScoreKeeperScreen extends ConsumerWidget {
  const ScoreKeeperScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable2(
          columnSpacing: 12,
          horizontalMargin: 12,
          minWidth: 800,
          fixedLeftColumns: 2,
          columns: [
            const DataColumn(label: Text('Player')),
            const DataColumn(label: Text('Total')),
            for (int i = 1; i <= 12; i++) DataColumn(label: Text('Round $i')),
          ],
          rows:
              players.map((player) {
                return DataRow(
                  cells: [
                    DataCell(
                      TextFormField(
                        initialValue: player.name,
                        onChanged:
                            (value) => ref
                                .read(playersProvider.notifier)
                                .updatePlayerName(player.id, value),
                      ),
                    ),
                    DataCell(Text(player.totalScore.toString())),
                    for (int i = 0; i < 12; i++)
                      DataCell(
                        Column(
                          children: [
                            TextFormField(
                              initialValue: player.scores[i]?.toString() ?? '',
                              keyboardType: TextInputType.number,
                              onChanged:
                                  (value) => ref
                                      .read(playersProvider.notifier)
                                      .updateScore(
                                        player.id,
                                        i,
                                        int.tryParse(value) ?? 0,
                                      ),
                            ),
                            DropdownButton<int>(
                              value: player.phases[i],
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text(''),
                                ),
                                for (int phase = 1; phase <= 10; phase++)
                                  DropdownMenuItem(
                                    value: phase,
                                    child: Text('Phase $phase'),
                                  ),
                              ],
                              onChanged:
                                  (value) => ref
                                      .read(playersProvider.notifier)
                                      .updatePhase(player.id, i, value),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}

// Riverpod State Management
final themeProvider = StateProvider<bool>((ref) => false);

final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>>(
  (ref) => PlayersNotifier(),
);

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier()
    : super(
        List.generate(
          8,
          (index) => Player(
            id: index,
            name: 'Player ${index + 1}',
            scores: List.filled(12, null),
          ),
        ),
      );

  void updatePlayerName(int id, String name) {
    state = [
      for (final player in state)
        if (player.id == id) player.copyWith(name: name) else player,
    ];
  }

  void updateScore(int id, int round, int score) {
    state = [
      for (final player in state)
        if (player.id == id)
          player.copyWith(
            scores: [
              for (int i = 0; i < player.scores.length; i++)
                if (i == round) score else player.scores[i],
            ],
          )
        else
          player,
    ];
  }

  void updatePhase(int id, int round, int? phase) {
    state = [
      for (final player in state)
        if (player.id == id)
          player.copyWith(
            phases: [
              for (int i = 0; i < player.phases.length; i++)
                if (i == round) phase else player.phases[i],
            ],
          )
        else
          player,
    ];
  }
}

// Player Model
class Player {
  final int id;
  final String name;
  final List<int?> scores;
  final List<int?> phases;

  Player({
    required this.id,
    required this.name,
    required this.scores,
    List<int?>? phases,
  }) : phases = phases ?? List.filled(12, null);

  int get totalScore =>
      scores.whereType<int>().fold(0, (sum, score) => sum + score);

  Player copyWith({String? name, List<int?>? scores, List<int?>? phases}) {
    return Player(
      id: id,
      name: name ?? this.name,
      scores: scores ?? this.scores,
      phases: phases ?? this.phases,
    );
  }
}
