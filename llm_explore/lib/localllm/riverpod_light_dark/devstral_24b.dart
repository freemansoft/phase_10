import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:phase_10_sandbox/screens/scoreboard_screen.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final theme = watch(themeProvider);

    return MaterialApp(
      title: 'Phase 10 Scoreboard',
      themeMode: theme,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: ScoreboardScreen(),
    );
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light());

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

final playersProvider = StateNotifierProvider<PlayerNotifier, List<Player>>((
  ref,
) {
  return PlayerNotifier();
});

class PlayerNotifier extends StateNotifier<List<Player>> {
  PlayerNotifier()
    : super(List.generate(8, (index) => Player(name: 'Player ${index + 1}')));

  void updateName(int index, String name) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Player(name: name, scores: state[i].scores)
        else
          state[i],
    ];
  }

  void updateScore(int playerIndex, int roundIndex, int score) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == playerIndex)
          Player(
            name: state[i].name,
            scores: [
              for (int j = 0; j < state[i].scores.length; j++)
                if (j == roundIndex) score else state[i].scores[j],
            ],
          )
        else
          state[i],
    ];
  }
}

class Player {
  String name;
  List<int> scores;

  Player({
    required this.name,
    this.scores = const [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  });

  int get totalScore => scores.reduce((a, b) => a + b);
}

class ScoreboardScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final players = watch(playersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scoreboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () => context.read(themeProvider.notifier).toggleTheme(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Player')),
            ...List.generate(
              12,
              (index) => DataColumn(label: Text('Round ${index + 1}')),
            ),
          ],
          rows:
              players.map((player) {
                return DataRow(
                  cells: [
                    DataCell(
                      TextField(
                        decoration: InputDecoration.collapsed(
                          hintText: 'Player Name',
                        ),
                        onChanged:
                            (value) => context
                                .read(playersProvider.notifier)
                                .updateName(players.indexOf(player), value),
                      ),
                    ),
                    ...List.generate(12, (index) {
                      return DataCell(
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: InputDecoration.collapsed(
                                  hintText: 'Score',
                                ),
                                keyboardType: TextInputType.number,
                                onChanged:
                                    (value) => context
                                        .read(playersProvider.notifier)
                                        .updateScore(
                                          players.indexOf(player),
                                          index,
                                          int.tryParse(value) ?? 0,
                                        ),
                              ),
                            ),
                            DropdownButton<int>(
                              value: player.scores[index],
                              items:
                                  List.generate(11, (i) => i + 1)
                                      .map(
                                        (e) => DropdownMenuItem(
                                          child: Text(e.toString()),
                                          value: e,
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {},
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
