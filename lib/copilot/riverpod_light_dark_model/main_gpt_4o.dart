import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

void main() {
  runApp(const ProviderScope(child: Phase10App()));
}

class Phase10App extends StatelessWidget {
  const Phase10App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final isDarkMode = ref.watch(themeProvider);
        return MaterialApp(
          title: 'Phase-10 Scoreboard',
          theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          home: const ScoreboardScreen(),
        );
      },
    );
  }
}

final themeProvider = StateProvider<bool>((ref) => false);

class Player {
  final String name;
  final List<int> scores;
  final List<int?> phases;

  Player(this.name)
      : scores = List.filled(12, 0),
        phases = List.filled(12, null);

  int get totalScore => scores.reduce((a, b) => a + b);
}

final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>>(
  (ref) => PlayersNotifier(),
);

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier()
      : super(List.generate(8, (index) => Player('Player ${index + 1}')));

  void updateScore(int playerIndex, int roundIndex, int score) {
    state[playerIndex].scores[roundIndex] = score;
    state = [...state];
  }

  void updatePhase(int playerIndex, int roundIndex, int? phase) {
    state[playerIndex].phases[roundIndex] = phase;
    state = [...state];
  }
}

class ScoreboardScreen extends ConsumerWidget {
  const ScoreboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase-10 Scoreboard'),
        actions: [
          Switch(
            value: ref.watch(themeProvider),
            onChanged: (value) =>
                ref.read(themeProvider.notifier).state = value,
          ),
        ],
      ),
      body: HorizontalDataTable(
        leftHandSideColumnWidth: 150,
        rightHandSideColumnWidth: 1200,
        isFixedHeader: true,
        headerWidgets: _buildHeader(),
        leftSideItemBuilder: (context, index) =>
            _buildLeftColumn(players[index]),
        rightSideItemBuilder: (context, index) =>
            _buildRightColumns(context, ref, players[index], index),
        itemCount: players.length,
        rowSeparatorWidget: const Divider(height: 1, color: Colors.black),
      ),
    );
  }

  List<Widget> _buildHeader() {
    return [
      const SizedBox(
        width: 150,
        child: Center(child: Text('Player / Total')),
      ),
      for (int i = 1; i <= 12; i++)
        SizedBox(
          width: 100,
          child: Center(child: Text('Round $i')),
        ),
    ];
  }

  Widget _buildLeftColumn(Player player) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(player.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text('Total: ${player.totalScore}'),
        ],
      ),
    );
  }

  Widget _buildRightColumns(
      BuildContext context, WidgetRef ref, Player player, int playerIndex) {
    return Row(
      children: List.generate(12, (roundIndex) {
        return SizedBox(
          width: 100,
          child: Column(
            children: [
              DropdownButton<int?>(
                value: player.phases[roundIndex],
                items: [null, ...List.generate(10, (i) => i + 1)]
                    .map((phase) => DropdownMenuItem(
                          value: phase,
                          child: Text(phase?.toString() ?? ''),
                        ))
                    .toList(),
                onChanged: (value) {
                  ref
                      .read(playersProvider.notifier)
                      .updatePhase(playerIndex, roundIndex, value);
                },
              ),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Score'),
                onChanged: (value) {
                  final score = int.tryParse(value) ?? 0;
                  ref
                      .read(playersProvider.notifier)
                      .updateScore(playerIndex, roundIndex, score);
                },
              ),
            ],
          ),
        );
      }),
    );
  }
}
