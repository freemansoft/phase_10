import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

// --- Models ---
class Scores {
  final List<int?> roundScores;
  Scores({List<int?>? roundScores})
      : roundScores = roundScores ?? List.filled(12, null);

  int get total => roundScores.fold(0, (sum, s) => sum + (s ?? 0));

  Scores copyWith({List<int?>? roundScores}) =>
      Scores(roundScores: roundScores ?? this.roundScores);
}

class Phases {
  final List<int?> completedPhases;
  Phases({List<int?>? completedPhases})
      : completedPhases = completedPhases ?? List.filled(12, null);

  Phases copyWith({List<int?>? completedPhases}) =>
      Phases(completedPhases: completedPhases ?? this.completedPhases);
}

class Player {
  final String name;
  final Scores scores;
  final Phases phases;
  Player({required this.name, required this.scores, required this.phases});

  Player copyWith({String? name, Scores? scores, Phases? phases}) => Player(
        name: name ?? this.name,
        scores: scores ?? this.scores,
        phases: phases ?? this.phases,
      );
}

// --- Providers ---
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final playersProvider =
    StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  return PlayersNotifier();
});

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier()
      : super(List.generate(
            8,
            (i) => Player(
                name: 'Player ${i + 1}', scores: Scores(), phases: Phases())));

  void updateScore(int playerIdx, int roundIdx, String value) {
    final score = int.tryParse(value);
    final updated = [
      for (int i = 0; i < state.length; i++)
        if (i == playerIdx)
          state[i].copyWith(
            scores: Scores(
              roundScores: [
                for (int j = 0; j < 12; j++)
                  if (j == roundIdx) score else state[i].scores.roundScores[j]
              ],
            ),
          )
        else
          state[i]
    ];
    state = updated;
  }

  void updatePhase(int playerIdx, int roundIdx, int? phase) {
    final updated = [
      for (int i = 0; i < state.length; i++)
        if (i == playerIdx)
          state[i].copyWith(
            phases: Phases(
              completedPhases: [
                for (int j = 0; j < 12; j++)
                  if (j == roundIdx)
                    phase
                  else
                    state[i].phases.completedPhases[j]
              ],
            ),
          )
        else
          state[i]
    ];
    state = updated;
  }
}

// --- Main App ---
void main() {
  runApp(const ProviderScope(child: Phase10App()));
}

class Phase10App extends ConsumerWidget {
  const Phase10App({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp(
      title: 'Phase-10 Scoreboard',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: themeMode,
      home: const ScoreboardScreen(),
    );
  }
}

class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase-10 Scoreboard'),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (v) => ref.read(themeModeProvider.notifier).state =
                    v ? ThemeMode.dark : ThemeMode.light,
              ),
              const Icon(Icons.dark_mode),
            ],
          ),
        ],
      ),
      body: HorizontalDataTable(
        leftHandSideColumnWidth: 160,
        rightHandSideColumnWidth: 12 * 120,
        isFixedHeader: true,
        headerWidgets: [
          Container(
            width: 160,
            alignment: Alignment.center,
            child: const Text(
              'Player / Total',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...List.generate(
            12,
            (i) => Container(
              width: 120,
              alignment: Alignment.center,
              child: Text(
                'Round ${i + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
        leftSideItemBuilder: (context, idx) => Container(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(players[idx].name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Total: ${players[idx].scores.total}',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        rightSideItemBuilder: (context, playerIdx) => Row(
          children: List.generate(
            12,
            (roundIdx) => SizedBox(
              width: 120,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value:
                          players[playerIdx].phases.completedPhases[roundIdx],
                      items: [
                        const DropdownMenuItem<int>(
                            value: null, child: Text('')),
                        ...List.generate(
                          10,
                          (i) => DropdownMenuItem<int>(
                            value: i + 1,
                            child: Text('${i + 1}'),
                          ),
                        ),
                      ],
                      onChanged: (val) => ref
                          .read(playersProvider.notifier)
                          .updatePhase(playerIdx, roundIdx, val),
                      decoration: const InputDecoration(
                        labelText: 'Phase',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                    TextFormField(
                      initialValue: players[playerIdx]
                          .scores
                          .roundScores[roundIdx]
                          ?.toString(),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Score',
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onChanged: (val) => ref
                          .read(playersProvider.notifier)
                          .updateScore(playerIdx, roundIdx, val),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        itemCount: players.length,
        rowSeparatorWidget: const Divider(height: 1, thickness: 0.5),
        leftHandSideColBackgroundColor: Theme.of(context).canvasColor,
        rightHandSideColBackgroundColor: Theme.of(context).canvasColor,
      ),
    );
  }
}
