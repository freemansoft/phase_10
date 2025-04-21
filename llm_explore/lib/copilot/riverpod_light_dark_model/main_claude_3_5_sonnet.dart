import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

// Models
class Player {
  final String name;
  final Scores scores;
  final Phases phases;

  Player({required this.name, required this.scores, required this.phases});

  Player copyWith({
    String? name,
    Scores? scores,
    Phases? phases,
  }) {
    return Player(
      name: name ?? this.name,
      scores: scores ?? this.scores,
      phases: phases ?? this.phases,
    );
  }
}

class Scores {
  List<int?> roundScores;
  int totalScore;

  Scores()
      : roundScores = List.filled(12, null),
        totalScore = 0;

  void updateScore(int round, int? score) {
    roundScores[round] = score;
    calculateTotal();
  }

  void calculateTotal() {
    totalScore = roundScores.fold(0, (sum, score) => sum + (score ?? 0));
  }
}

class Phases {
  List<int?> completedPhases;

  Phases() : completedPhases = List.filled(12, null);

  void updatePhase(int round, int? phase) {
    completedPhases[round] = phase;
  }
}

// Providers
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final playersProvider =
    StateNotifierProvider<PlayersNotifier, List<Player>>((ref) {
  return PlayersNotifier();
});

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier()
      : super(
          List.generate(
            8,
            (index) => Player(
              name: 'Player ${index + 1}',
              scores: Scores(),
              phases: Phases(),
            ),
          ),
        );

  void updateScore(int playerIndex, int round, String value) {
    final score = int.tryParse(value);
    state = [
      ...state.asMap().map((index, player) {
        if (index == playerIndex) {
          final newScores = Scores()
            ..roundScores = List.from(player.scores.roundScores)
            ..updateScore(round, score);
          return MapEntry(index, player.copyWith(scores: newScores));
        }
        return MapEntry(index, player);
      }).values
    ];
  }

  void updatePhase(int playerIndex, int round, int? phase) {
    state = [
      ...state.asMap().map((index, player) {
        if (index == playerIndex) {
          final newPhases = Phases()
            ..completedPhases = List.from(player.phases.completedPhases)
            ..updatePhase(round, phase);
          return MapEntry(index, player.copyWith(phases: newPhases));
        }
        return MapEntry(index, player);
      }).values
    ];
  }
}

// App
void main() {
  runApp(const ProviderScope(child: PhaseScoreApp()));
}

class PhaseScoreApp extends ConsumerWidget {
  const PhaseScoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Phase-10 Scoreboard',
      themeMode: themeMode,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
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
          Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: HorizontalDataTable(
        leftHandSideColumnWidth: 150,
        rightHandSideColumnWidth: 12 * 120,
        isFixedHeader: true,
        headerWidgets: _buildHeader(),
        leftSideItemBuilder: (context, index) => Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(players[index].name),
              Text('Total: ${players[index].scores.totalScore}'),
            ],
          ),
        ),
        rightSideItemBuilder: (context, index) => Row(
          children: List.generate(
            12,
            (round) => SizedBox(
              width: 120,
              child: Column(
                children: [
                  DropdownButtonFormField<int?>(
                    value: players[index].phases.completedPhases[round],
                    items: [
                      const DropdownMenuItem(value: null, child: Text('')),
                      ...List.generate(
                        10,
                        (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text('${i + 1}'),
                        ),
                      )
                    ],
                    onChanged: (value) {
                      ref
                          .read(playersProvider.notifier)
                          .updatePhase(index, round, value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'Phase',
                      isDense: true,
                    ),
                  ),
                  TextFormField(
                    initialValue:
                        players[index].scores.roundScores[round]?.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Score',
                      isDense: true,
                    ),
                    onChanged: (value) {
                      ref
                          .read(playersProvider.notifier)
                          .updateScore(index, round, value);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        itemCount: players.length,
      ),
    );
  }

  List<Widget> _buildHeader() {
    return [
      Container(
        width: 150,
        alignment: Alignment.center,
        child: const Text(
          'Players',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ...List.generate(
        12,
        (index) => Container(
          width: 120,
          alignment: Alignment.center,
          child: Text(
            'Round ${index + 1}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];
  }
}
