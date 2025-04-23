import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

final themeProvider = StateProvider<bool>((ref) => true);

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}

final scoresProvider = StateNotifierProvider<ScoresNotifier, ScoresState>(
  (ref) => ScoresNotifier(),
);

class ScoresState {
  final List<Player> players;

  ScoresState({required this.players});

  int getTotalScore(int playerIndex) =>
      players[playerIndex].roundScores.reduce((a, b) => a + b);
}

class Player {
  String name;
  List<int> roundScores; // 0 means no score for that phase

  Player({required this.name, required this.roundScores});
}

class ScoresNotifier extends StateNotifier<ScoresState> {
  ScoresNotifier()
    : super(
        ScoresState(
          players: List.generate(
            8,
            (index) => Player(
              name: 'Player ${index + 1}',
              roundScores: List.filled(12, 0),
            ),
          ),
        ),
      );

  void setPlayerName(int playerIndex, String name) {
    final updatedPlayers = state.players.toList();
    updatedPlayers[playerIndex] = updatedPlayers[playerIndex].copyWith(
      name: name,
    );
    state = ScoresState(players: updatedPlayers);
  }

  void setRoundScore(int playerIndex, int roundIndex, int score) {
    final updatedPlayers = state.players.toList();
    final updatedScores = updatedPlayers[playerIndex].roundScores.toList();
    updatedScores[roundIndex] = score;
    updatedPlayers[playerIndex] = updatedPlayers[playerIndex].copyWith(
      roundScores: updatedScores,
    );
    state = ScoresState(players: updatedPlayers);
  }

  void setPhase(int playerIndex, int roundIndex, String phase) {
    // You can add logic here to handle the phase dropdown if needed
  }
}

extension PlayerCopy on Player {
  Player copyWith({String? name, List<int>? roundScores}) {
    return Player(
      name: name ?? this.name,
      roundScores: roundScores ?? this.roundScores,
    );
  }
}

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresState = ref.watch(scoresProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Score Keeper'),
        actions: [
          Switch.adaptive(
            value: !ref.watch(themeProvider),
            onChanged: (_) => themeNotifier.update((state) => !state),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StickyHeadersTable(
          columnsLength:
              25, // 1 for player name/score + 12 rounds * 2 fields per round
          rowsLength: scoresState.players.length,
          columnsTitleBuilder: (i) {
            if (i == 0) return const Text('Player/Score');
            final roundIndex = (i - 1) ~/ 2;
            final fieldIndex = (i - 1) % 2;
            if (fieldIndex == 0) {
              return Column(
                children: [
                  Text('Round ${roundIndex + 1}'),
                  const Text('Score'),
                ],
              );
            }
            return Column(
              children: [Text('Round ${roundIndex + 1}'), const Text('Phase')],
            );
          },
          rowsTitleBuilder: (i) {
            final player = scoresState.players[i];
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(player.name)),
                Text(scoresState.getTotalScore(i).toString()),
              ],
            );
          },
          contentCellBuilder: (i, j) {
            if (j == 0) {
              final player = scoresState.players[i];
              return TextField(
                controller: TextEditingController(text: player.name),
                onChanged:
                    (value) => ref
                        .read(scoresProvider.notifier)
                        .setPlayerName(i, value),
              );
            }
            final roundIndex = (j - 1) ~/ 2;
            if ((j - 1) % 2 == 0) {
              return TextField(
                controller: TextEditingController(
                  text:
                      scoresState.players[i].roundScores[roundIndex].toString(),
                ),
                onChanged:
                    (value) => ref
                        .read(scoresProvider.notifier)
                        .setRoundScore(i, roundIndex, int.tryParse(value) ?? 0),
                keyboardType: TextInputType.number,
              );
            }
            return DropdownButton<String>(
              value: null,
              items: List.generate(11, (index) {
                final phase = index == 0 ? '' : index.toString();
                return DropdownMenuItem(value: phase, child: Text(phase));
              }),
              onChanged:
                  (value) => ref
                      .read(scoresProvider.notifier)
                      .setPhase(i, roundIndex, value!),
            );
          },
          legendCell: const Text('Players/Rounds'),
        ),
      ),
    );
  }
}
