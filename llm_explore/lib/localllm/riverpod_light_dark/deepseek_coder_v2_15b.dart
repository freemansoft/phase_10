import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:data_table2/data_table2.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      darkTheme: ThemeData.dark(),
      lightTheme: ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(title: Text('Phase 10 Score Keeper')),
        body: Phase10ScoreKeeper(),
      ),
    );
  }
}

class Player {
  String name;
  List<int> scores = List.filled(12, 0);

  Player({required this.name});
}

final playersProvider =
    StateNotifierProvider<PlayersNotifier, Map<String, Player>>((ref) {
      return PlayersNotifier();
    });

class PlayersNotifier extends StateNotifier<Map<String, Player>> {
  PlayersNotifier() : super({});

  void addPlayer(String name) {
    state = {...state, name: Player(name: name)};
  }

  void updateScore(String playerName, int round, int score, [int phase = -1]) {
    if (state.containsKey(playerName)) {
      var player = state[playerName]!;
      player.scores[round] = score;
      if (phase != -1)
        player.scores[12 + phase] = 1; // Assuming phase adds points
      state = {...state, playerName: player};
    }
  }
}

class Phase10ScoreKeeper extends ConsumerStatefulWidget {
  @override
  _Phase10ScoreKeeperState createState() => _Phase10ScoreKeeperState();
}

class _Phase10ScoreKeeperState extends ConsumerState<Phase10ScoreKeeper> {
  late DataTable2Source<Player> source;

  @override
  void initState() {
    super.initState();
    source = buildSource(ref);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 600,
        columns: [
          DataColumn(label: Text('Player Name'), numeric: false),
          for (int i = 0; i < 12; i++)
            DataColumn(label: Text('Round ${i + 1}')),
          for (int i = 0; i < 10; i++)
            DataColumn(label: Text('Phase ${i + 1}')),
        ],
        rows:
            source.data.map((player) {
              return DataRow(
                cells: [
                  DataCell(
                    TextFormField(
                      initialValue: player.name,
                      onChanged:
                          (value) => ref
                              .read(playersProvider.notifier)
                              .updatePlayerName(value),
                    ),
                  ),
                  for (int score in player.scores.take(12))
                    DataCell(
                      TextField(
                        initialValue: '$score',
                        keyboardType: TextInputType.number,
                        onChanged:
                            (value) => ref
                                .read(playersProvider.notifier)
                                .updateScore(player.name, value),
                      ),
                      onTap: () {},
                    ),
                  for (int score in player.scores.skip(12))
                    DataCell(
                      DropdownButton<int>(
                        items: [
                          DropdownMenuItem(child: Text(''), value: null),
                          ...List.generate(
                            10,
                            (index) => DropdownMenuItem(
                              child: Text('$index'),
                              value: index,
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          ref
                              .read(playersProvider.notifier)
                              .updateScore(player.name, value);
                        },
                      ),
                      onTap: () {},
                    ),
                ],
              );
            }).toList(),
      ),
    );
  }
}

class PlayersNotifier extends StateNotifier<Map<String, Player>> {
  PlayersNotifier() : super({});

  void addPlayer(String name) {
    state = {...state, name: Player(name: name)};
  }

  void updateScore(String playerName, int round, int score, [int phase = -1]) {
    if (state.containsKey(playerName)) {
      var player = state[playerName]!;
      player.scores[round] = score;
      if (phase != -1)
        player.scores[12 + phase] = 1; // Assuming phase adds points
      state = {...state, playerName: player};
    }
  }
}

DataTable2Source<Player> buildSource(WidgetRef ref) {
  return DataTable2Source<Player>(
    data: ref.read(playersProvider).values.toList(),
  );
}
