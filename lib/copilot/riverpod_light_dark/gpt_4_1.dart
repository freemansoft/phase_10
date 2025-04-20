import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: Phase10App()));
}

class Phase10App extends ConsumerStatefulWidget {
  const Phase10App({super.key});

  @override
  ConsumerState<Phase10App> createState() => _Phase10AppState();
}

class _Phase10AppState extends ConsumerState<Phase10App> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Phase 10 Scorekeeper'),
          actions: [
            Row(
              children: [
                const Icon(Icons.light_mode),
                Switch(
                  value: isDark,
                  onChanged: (v) => setState(() => isDark = v),
                ),
                const Icon(Icons.dark_mode),
              ],
            ),
          ],
        ),
        body: const Phase10Table(),
      ),
    );
  }
}

// --- Riverpod State Management ---

class Player {
  String name;
  List<int?> scores; // 12 rounds, nullable for empty
  List<int?> phases; // 12 rounds, nullable for blank/none

  Player({required this.name})
    : scores = List.filled(12, null),
      phases = List.filled(12, null);

  int get totalScore => scores.fold(0, (sum, s) => sum + (s ?? 0));
}

class GameState {
  final List<Player> players;

  GameState({required this.players});

  GameState copyWith({List<Player>? players}) =>
      GameState(players: players ?? this.players);
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});

class GameNotifier extends StateNotifier<GameState> {
  GameNotifier()
    : super(
        GameState(
          players: List.generate(8, (i) => Player(name: 'Player ${i + 1}')),
        ),
      );

  void updatePlayerName(int playerIdx, String name) {
    final players = [...state.players];
    players[playerIdx] =
        Player(name: name)
          ..scores = List.from(state.players[playerIdx].scores)
          ..phases = List.from(state.players[playerIdx].phases);
    state = state.copyWith(players: players);
  }

  void updateScore(int playerIdx, int roundIdx, int? score) {
    final players = [...state.players];
    players[playerIdx].scores[roundIdx] = score;
    state = state.copyWith(players: players);
  }

  void updatePhase(int playerIdx, int roundIdx, int? phase) {
    final players = [...state.players];
    players[playerIdx].phases[roundIdx] = phase;
    state = state.copyWith(players: players);
  }
}

// --- Table UI ---

class Phase10Table extends ConsumerWidget {
  const Phase10Table({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fixed first column
          Column(
            children: [
              _headerCell('Player / Total'),
              ...List.generate(game.players.length, (playerIdx) {
                final player = game.players[playerIdx];
                return SizedBox(
                  width: 140,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: player.name,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged:
                              (v) => ref
                                  .read(gameProvider.notifier)
                                  .updatePlayerName(playerIdx, v),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          player.totalScore.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
          // Scrollable rounds columns
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(12, (roundIdx) {
                  return Column(
                    children: [
                      _headerCell('R${roundIdx + 1}'),
                      ...List.generate(game.players.length, (playerIdx) {
                        final player = game.players[playerIdx];
                        return SizedBox(
                          width: 110,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: TextFormField(
                                  initialValue:
                                      player.scores[roundIdx]?.toString() ?? '',
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: 'Score',
                                    border: InputBorder.none,
                                  ),
                                  onChanged:
                                      (v) => ref
                                          .read(gameProvider.notifier)
                                          .updateScore(
                                            playerIdx,
                                            roundIdx,
                                            int.tryParse(v),
                                          ),
                                ),
                              ),
                              SizedBox(
                                width: 50,
                                child: DropdownButtonFormField<int>(
                                  value: player.phases[roundIdx],
                                  isDense: true,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  items: [
                                    const DropdownMenuItem<int>(
                                      value: null,
                                      child: Text(''),
                                    ),
                                    ...List.generate(
                                      10,
                                      (i) => DropdownMenuItem<int>(
                                        value: i + 1,
                                        child: Text('${i + 1}'),
                                      ),
                                    ),
                                  ],
                                  onChanged:
                                      (v) => ref
                                          .read(gameProvider.notifier)
                                          .updatePhase(playerIdx, roundIdx, v),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCell(String text) => Container(
    width: 140,
    height: 48,
    alignment: Alignment.center,
    color: Colors.grey[300],
    child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
  );
}
