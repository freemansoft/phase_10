import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';

void main() {
  runApp(const ProviderScope(child: Phase10App()));
}

class Phase10App extends ConsumerWidget {
  const Phase10App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider);

    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      home: const ScoreTable(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ScoreTable extends ConsumerStatefulWidget {
  const ScoreTable({Key? key}) : super(key: key);

  @override
  ConsumerState<ScoreTable> createState() => _ScoreTableState();
}

class _ScoreTableState extends ConsumerState<ScoreTable> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Score Keeper'),
        actions: [
          Consumer(
            builder: (context, ref, _) {
              return Switch(
                value: ref.watch(darkModeProvider),
                onChanged: (value) {
                  ref.read(darkModeProvider.notifier).state = value;
                },
              );
            },
          ),
        ],
      ),
      body: const ScoreDataTable(),
    );
  }
}

class ScoreDataTable extends ConsumerWidget {
  const ScoreDataTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(playersProvider);
    final roundCount = 12;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 2400,
        columns: [
          const DataColumn(label: Text('Player')),
          const DataColumn(label: Text('Total')),
          for (int i = 1; i <= roundCount; i++)
            DataColumn(label: Text('Round $i')),
        ],
        rows: List<DataRow>.generate(players.length, (index) {
          final player = players[index];
          return DataRow(
            cells: [
              DataCell(
                TextFormField(
                  initialValue: player.name,
                  onChanged: (value) {
                    ref
                        .read(playersProvider.notifier)
                        .updatePlayerName(index, value);
                  },
                ),
              ),
              DataCell(Text(player.totalScore.toString())),
              for (int i = 0; i < roundCount; i++)
                DataCell(RoundScoreInput(playerIndex: index, roundIndex: i)),
            ],
          );
        }),
      ),
    );
  }
}

class RoundScoreInput extends ConsumerWidget {
  const RoundScoreInput({
    Key? key,
    required this.playerIndex,
    required this.roundIndex,
  }) : super(key: key);

  final int playerIndex;
  final int roundIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playersProvider)[playerIndex];
    final roundScore = player.roundScores[roundIndex];

    return Column(
      children: [
        SizedBox(
          width: 75,
          child: TextFormField(
            initialValue:
                roundScore.score != null ? roundScore.score.toString() : '',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final score = int.tryParse(value);
              ref
                  .read(playersProvider.notifier)
                  .updateRoundScore(
                    playerIndex,
                    roundIndex,
                    score,
                    roundScore.phase,
                  );
            },
          ),
        ),
        DropdownButton<int?>(
          value: roundScore.phase,
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('None')),
            for (int i = 1; i <= 10; i++)
              DropdownMenuItem<int?>(value: i, child: Text(i.toString())),
          ],
          onChanged: (value) {
            ref
                .read(playersProvider.notifier)
                .updateRoundScore(
                  playerIndex,
                  roundIndex,
                  roundScore.score,
                  value,
                );
          },
        ),
      ],
    );
  }
}

// --- State Management ---

final darkModeProvider = StateProvider((ref) => false);

class Player {
  Player({required this.name, required this.roundScores});

  String name;
  List<RoundScore> roundScores;

  int get totalScore =>
      roundScores.fold(0, (sum, round) => sum + (round.score ?? 0));
}

class RoundScore {
  RoundScore({this.score, this.phase});

  int? score;
  int? phase;
}

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier()
    : super(
        List.generate(
          8,
          (index) => Player(
            name: 'Player ${index + 1}',
            roundScores: List.generate(12, (index) => RoundScore()),
          ),
        ),
      );

  void updatePlayerName(int index, String name) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == index)
          Player(name: name, roundScores: state[i].roundScores)
        else
          state[i],
    ];
  }

  void updateRoundScore(
    int playerIndex,
    int roundIndex,
    int? score,
    int? phase,
  ) {
    state = [
      for (int i = 0; i < state.length; i++)
        if (i == playerIndex)
          Player(
            name: state[i].name,
            roundScores: [
              for (int j = 0; j < state[i].roundScores.length; j++)
                if (j == roundIndex)
                  RoundScore(score: score, phase: phase)
                else
                  state[i].roundScores[j],
            ],
          )
        else
          state[i],
    ];
  }
}

final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>>(
  (ref) => PlayersNotifier(),
);
