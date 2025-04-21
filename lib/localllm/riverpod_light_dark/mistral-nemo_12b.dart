import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';
import 'package:data_table_2/data_table_2.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, _) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      themeMode: context.select((ThemeNotifier notifier) => notifier.mode),
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, _) {
    final players = context.watch<PlayersNotifier>().players;
    final totalScores = context.select(
      (PlayersNotifier notifier) => notifier.totalScores,
    );

    return Scaffold(
      appBar: AppBar(title: Text('Phase 10')),
      body: Column(
        children: [
          SwitchListTile.adaptiveValue(
            title: Text('Dark Mode'),
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              context.read<ThemeNotifier>().toggleMode();
            },
          ),
          Expanded(
            child: TableStickyHeaders(
              headerHeight: 50,
              columnWidths: {0: FixedColumnWidth(200)},
              columns: [
                'Player Name',
                'Total',
                ...List.generate(12, (i) => 'Round ${i + 1}'),
              ],
              data: List.generate(players.length, (index) {
                final player = players[index];
                return [
                  TextField(
                    controller: TextEditingController(text: player.name),
                    onChanged:
                        (value) => context
                            .read<PlayersNotifier>()
                            .updatePlayerName(index, value),
                  ),
                  Text('${totalScores[index]}'),
                  ...List.generate(12, (roundIndex) {
                    final roundScore = player.roundScores[roundIndex];
                    return Row(
                      children: [
                        TextField(
                          controller: TextEditingController(
                            text: roundScore.score.toString(),
                          ),
                          onChanged:
                              (value) => context
                                  .read<PlayersNotifier>()
                                  .updateRoundScore(
                                    index,
                                    roundIndex,
                                    int.tryParse(value),
                                  ),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: roundScore.phase,
                            onChanged:
                                (value) => context
                                    .read<PlayersNotifier>()
                                    .updatePhase(index, roundIndex, value),
                            items:
                                List.generate(11, (i) => i)
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text('Phase $e'),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ],
                    );
                  }),
                ];
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier() : super(List.generate(8, (index) => Player(index: index)));

  void updatePlayerName(int playerIndex, String name) {
    state[playerIndex].name = name;
  }

  void updateRoundScore(int playerIndex, int roundIndex, int score) {
    state[playerIndex].roundScores[roundIndex] = RoundScore(score: score);
  }

  void updatePhase(int playerIndex, int roundIndex, int phase) {
    state[playerIndex].roundScores[roundIndex].phase = phase;
  }

  List<int> get totalScores =>
      state
          .map(
            (player) => player.roundScores.fold(0, (sum, rs) => sum + rs.score),
          )
          .toList();
}

class Player {
  final int index;
  String name;
  List<RoundScore> roundScores;

  Player({required this.index})
    : name = 'Player ${index + 1}',
      roundScores = List.generate(12, (i) => RoundScore());

  @override
  String toString() {
    return '{name: $name, roundScores: $roundScores}';
  }
}

class RoundScore {
  int score;
  int phase;

  RoundScore({this.score = 0, this.phase = -1});

  @override
  String toString() {
    return '{score: $score, phase: $phase}';
  }
}

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void toggleMode() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
