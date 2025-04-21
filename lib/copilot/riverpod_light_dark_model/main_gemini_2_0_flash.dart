import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class Player {
  String name;
  Scores scores;
  Phases phases;

  Player({required this.name, required this.scores, required this.phases});
}

class Scores {
  List<int?> roundScores = List.generate(12, (index) => null);
  int totalScore = 0;

  void updateScore(int roundIndex, int? newScore) {
    roundScores[roundIndex] = newScore;
    calculateTotalScore();
  }

  void calculateTotalScore() {
    totalScore = roundScores.fold(0, (sum, score) => sum + (score ?? 0));
  }
}

class Phases {
  List<int?> completedPhases = List.generate(12, (index) => null);

  void updatePhase(int roundIndex, int? newPhase) {
    completedPhases[roundIndex] = newPhase;
  }
}

final playersProvider = StateProvider<List<Player>>((ref) {
  return List.generate(
    8,
    (index) => Player(
      name: 'Player ${index + 1}',
      scores: Scores(),
      phases: Phases(),
    ),
  );
});

final themeModeProvider = StateProvider((ref) => ThemeMode.light);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Phase-10 Scoreboard',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeMode,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final players = ref.watch(playersProvider);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase-10 Scoreboard'),
        actions: [
          Switch(
            value: themeMode == ThemeMode.dark,
            onChanged: (newValue) {
              ref.read(themeModeProvider.notifier).state =
                  newValue ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: HorizontalDataTable(
        leftHandSideColumnWidth: 150,
        rightHandSideColumnWidth: 12 * 150,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: (BuildContext context, int index) {
          return Text(
              '${players[index].name}\nTotal: ${players[index].scores.totalScore}');
        },
        rightSideItemBuilder: (BuildContext context, int index) {
          return Row(
            children: List.generate(
              12,
              (roundIndex) => SizedBox(
                width: 150,
                child: Column(
                  children: [
                    DropdownButtonFormField<int>(
                      value: players[index].phases.completedPhases[roundIndex],
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text(''),
                        ),
                        ...List.generate(
                          10,
                          (phaseIndex) => DropdownMenuItem<int>(
                            value: phaseIndex + 1,
                            child: Text('${phaseIndex + 1}'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        ref.read(playersProvider.notifier).update((state) {
                          final newPlayers = [...state];
                          newPlayers[index]
                              .phases
                              .updatePhase(roundIndex, value);
                          return newPlayers;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Phase'),
                    ),
                    TextFormField(
                      initialValue: players[index]
                              .scores
                              .roundScores[roundIndex]
                              ?.toString() ??
                          '',
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        final score = int.tryParse(value);
                        ref.read(playersProvider.notifier).update((state) {
                          final newPlayers = [...state];
                          newPlayers[index]
                              .scores
                              .updateScore(roundIndex, score);
                          return newPlayers;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Score'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: players.length,
        rowSeparatorWidget: const Divider(
          color: Colors.black54,
          height: 1.0,
          thickness: 0.0,
        ),
        // manually commented out duplicate lines
        // leftHandSideColumnWidth: 150,
        // rightHandSideColumnWidth: 12 * 150,
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Player', 150),
      ...List.generate(
          12, (index) => _getTitleItemWidget('Round ${index + 1}', 150))
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      width: width,
      height: 56,
      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
