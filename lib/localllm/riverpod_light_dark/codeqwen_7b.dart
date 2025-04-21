import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_table/flutter_table.dart';

final phase10Provider = StateNotifierProvider<Phase10, List<Player>>(
  (_) => Phase10(),
);

class Player {
  String name;
  List<int> scores;

  Player({required this.name, required this.scores});
}

class Phase10 extends StateNotifier<List<Player>> {
  Phase10() : super([]);

  void addPlayer(String playerName) {
    state = [...state, Player(name: playerName, scores: List.filled(12, 0))];
  }

  void updateScore({
    required int playerIndex,
    required int roundIndex,
    required int score,
  }) {
    final players = [...state];
    players[playerIndex].scores[roundIndex] = score;
    state = players;
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase10 = ref.watch(phase10Provider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      theme: ThemeData(brightness: Brightness.light),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: themeMode,
      home: Scaffold(
        appBar: AppBar(title: Text('Phase 10 Score Tracker')),
        body: SingleChildScrollView(
          child: Table(
            border: TableBorder.all(),
            children: [
              TableRow(
                children:
                    phase10.map((player) {
                      return TableCell(
                        child: TextField(
                          controller: TextEditingController(text: player.name),
                        ),
                      );
                    }).toList(),
              ),
              for (int i = 0; i < 12; i++)
                TableRow(
                  children:
                      phase10.map((player) {
                        return TableCell(
                          child: TextField(
                            controller: TextEditingController(
                              text: player.scores[i].toString(),
                            ),
                          ),
                        );
                      }).toList(),
                ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ref.read(phase10Provider).addPlayer('New Player');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

final themeModeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((
  ref,
) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void toggleTheme() {
    state = state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
