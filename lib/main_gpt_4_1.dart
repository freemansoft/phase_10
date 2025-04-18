import 'package:flutter/material.dart';

void main() {
  runApp(const Phase10App());
}

class Phase10App extends StatelessWidget {
  const Phase10App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const Phase10ScorePage(),
    );
  }
}

class Player {
  String name;
  List<int?> roundScores;
  List<int?> phaseCompleted;

  Player({required this.name, int rounds = 12})
      : roundScores = List<int?>.filled(rounds, null),
        phaseCompleted = List<int?>.filled(rounds, null);

  int get totalScore => roundScores.fold(0, (sum, score) => sum + (score ?? 0));
}

class Phase10ScorePage extends StatefulWidget {
  const Phase10ScorePage({super.key});

  @override
  State<Phase10ScorePage> createState() => _Phase10ScorePageState();
}

class _Phase10ScorePageState extends State<Phase10ScorePage> {
  static const int playerCount = 8;
  static const int roundCount = 12;
  final List<Player> players = List.generate(
    playerCount,
    (i) => Player(name: 'Player ${i + 1}'),
  );

  final ScrollController _horizontalController = ScrollController();

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phase 10 Scorekeeper')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed first column
            Column(
              children: [
                // Header
                Container(
                  width: 140,
                  height: 60,
                  alignment: Alignment.center,
                  color: Colors.grey[300],
                  child: const Text(
                    'Player\nTotal',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Player rows
                ...players.map((player) {
                  int idx = players.indexOf(player);
                  return Container(
                    width: 140,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[300]!),
                        right: const BorderSide(color: Colors.grey),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Editable player name
                        Expanded(
                          child: TextFormField(
                            initialValue: player.name,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 8),
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            onChanged: (value) {
                              setState(() {
                                player.name = value;
                              });
                            },
                          ),
                        ),
                        // Total score
                        Container(
                          width: 40,
                          alignment: Alignment.centerRight,
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
                controller: _horizontalController,
                child: Column(
                  children: [
                    // Header row
                    Row(
                      children: List.generate(roundCount, (roundIdx) {
                        return Container(
                          width: 140,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey[300]!),
                            ),
                            color: Colors.grey[200],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Round ${roundIdx + 1}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              const Text('Score / Phase',
                                  style: TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      }),
                    ),
                    // Player rows
                    ...players.map((player) {
                      int playerIdx = players.indexOf(player);
                      return Row(
                        children: List.generate(roundCount, (roundIdx) {
                          return Container(
                            width: 140,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey[300]!),
                                bottom: BorderSide(color: Colors.grey[300]!),
                              ),
                            ),
                            child: Row(
                              children: [
                                // Score input
                                SizedBox(
                                  width: 60,
                                  child: TextFormField(
                                    initialValue: player.roundScores[roundIdx]
                                            ?.toString() ??
                                        '',
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        player.roundScores[roundIdx] =
                                            int.tryParse(value) ?? 0;
                                      });
                                    },
                                  ),
                                ),
                                // Phase dropdown
                                SizedBox(
                                  width: 70,
                                  child: DropdownButtonFormField<int>(
                                    value: player.phaseCompleted[roundIdx],
                                    isDense: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 4),
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
                                    onChanged: (value) {
                                      setState(() {
                                        player.phaseCompleted[roundIdx] = value;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
