import 'package:flutter/material.dart';

void main() {
  runApp(const Phase10ScoreKeeperApp());
}

class Phase10ScoreKeeperApp extends StatelessWidget {
  const Phase10ScoreKeeperApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ScoreKeeperPage(),
    );
  }
}

class ScoreKeeperPage extends StatefulWidget {
  const ScoreKeeperPage({super.key});

  @override
  State<ScoreKeeperPage> createState() => _ScoreKeeperPageState();
}

class _ScoreKeeperPageState extends State<ScoreKeeperPage> {
  static const int playerCount = 8;
  static const int roundCount = 12;
  static const List<String> phaseOptions = [
    '',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  List<String> playerNames = List.generate(
    playerCount,
    (i) => 'Player ${i + 1}',
  );
  List<List<int?>> scores = List.generate(
    playerCount,
    (_) => List.filled(roundCount, null),
  );
  List<List<String>> phases = List.generate(
    playerCount,
    (_) => List.filled(roundCount, ''),
  );

  int totalScore(int playerIdx) {
    return scores[playerIdx].fold(0, (sum, val) => sum + (val ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phase 10 Score Keeper')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            children: [
              // Frozen first column
              SizedBox(
                width: 180,
                child: ListView.builder(
                  itemCount: playerCount + 1,
                  itemBuilder: (context, rowIdx) {
                    if (rowIdx == 0) {
                      return Container(
                        height: 70,
                        alignment: Alignment.center,
                        color: Colors.grey[200],
                        child: const Text(
                          'Player / Total',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    int playerIdx = rowIdx - 1;
                    return Container(
                      height: 70,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                        color:
                            playerIdx % 2 == 0 ? Colors.white : Colors.grey[50],
                      ),
                      child: Row(
                        children: [
                          // Editable player name
                          SizedBox(
                            width: 90,
                            child: TextFormField(
                              initialValue: playerNames[playerIdx],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  playerNames[playerIdx] = val;
                                });
                              },
                            ),
                          ),
                          // Total score
                          Container(
                            width: 70,
                            alignment: Alignment.centerRight,
                            child: Text(
                              totalScore(playerIdx).toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Scrollable rounds
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: roundCount * 120,
                    child: ListView.builder(
                      itemCount: playerCount + 1,
                      itemBuilder: (context, rowIdx) {
                        if (rowIdx == 0) {
                          // Header row
                          return Row(
                            children: List.generate(roundCount, (roundIdx) {
                              return Container(
                                width: 120,
                                height: 70,
                                alignment: Alignment.center,
                                color: Colors.grey[200],
                                child: Text(
                                  'Round ${roundIdx + 1}\n(Score/Phase)',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            }),
                          );
                        }
                        int playerIdx = rowIdx - 1;
                        return Row(
                          children: List.generate(roundCount, (roundIdx) {
                            return Container(
                              width: 120,
                              height: 70,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.grey[300]!),
                                  right: BorderSide(color: Colors.grey[300]!),
                                ),
                                color:
                                    playerIdx % 2 == 0
                                        ? Colors.white
                                        : Colors.grey[50],
                              ),
                              child: Row(
                                children: [
                                  // Score input
                                  SizedBox(
                                    width: 60,
                                    child: TextFormField(
                                      initialValue:
                                          scores[playerIdx][roundIdx]
                                              ?.toString() ??
                                          '',
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                      ),
                                      onChanged: (val) {
                                        setState(() {
                                          scores[playerIdx][roundIdx] =
                                              int.tryParse(val);
                                        });
                                      },
                                    ),
                                  ),
                                  // Phase dropdown
                                  SizedBox(
                                    width: 60,
                                    child: DropdownButtonFormField<String>(
                                      value: phases[playerIdx][roundIdx],
                                      items:
                                          phaseOptions
                                              .map(
                                                (phase) => DropdownMenuItem(
                                                  value: phase,
                                                  child: Text(
                                                    phase.isEmpty ? '-' : phase,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          phases[playerIdx][roundIdx] =
                                              val ?? '';
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
