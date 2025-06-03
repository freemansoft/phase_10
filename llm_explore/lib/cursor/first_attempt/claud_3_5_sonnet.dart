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
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const ScoreKeeperScreen(),
    );
  }
}

class Player {
  String name;
  List<int> scores;
  List<int?> phases;

  Player({required this.name})
    : scores = List.filled(12, 0),
      phases = List.filled(12, null);

  int get totalScore => scores.fold(0, (sum, score) => sum + score);
}

class ScoreKeeperScreen extends StatefulWidget {
  const ScoreKeeperScreen({super.key});

  @override
  State<ScoreKeeperScreen> createState() => _ScoreKeeperScreenState();
}

class _ScoreKeeperScreenState extends State<ScoreKeeperScreen> {
  final List<Player> players = List.generate(
    8,
    (index) => Player(name: 'Player ${index + 1}'),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phase 10 Score Keeper')),
      body: SingleChildScrollView(
        child: Row(
          children: [
            // Frozen first column
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  // Header
                  Container(
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Text(
                      'Player / Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Player names and totals
                  ...players
                      .map(
                        (player) => Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Editable player name
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: TextField(
                                  controller: TextEditingController(
                                    text: player.name,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      player.name = value;
                                    });
                                  },
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding: EdgeInsets.all(8),
                                  ),
                                ),
                              ),
                              // Total score
                              Text(
                                'Total: ${player.totalScore}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            // Scrollable rounds columns
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    // Header row with round numbers
                    Row(
                      children: List.generate(
                        12,
                        (index) => Container(
                          width: 120,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Text(
                            'Round ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    // Player rows with scores and phases
                    ...players
                        .map(
                          (player) => Row(
                            children: List.generate(
                              12,
                              (roundIndex) => Container(
                                width: 120,
                                height: 100,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Score input
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      controller: TextEditingController(
                                        text:
                                            player.scores[roundIndex]
                                                .toString(),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          player.scores[roundIndex] =
                                              int.tryParse(value) ?? 0;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.all(8),
                                        labelText: 'Score',
                                      ),
                                    ),
                                    // Phase dropdown
                                    DropdownButton<int?>(
                                      value: player.phases[roundIndex],
                                      hint: const Text('Phase'),
                                      isExpanded: true,
                                      items: [
                                        const DropdownMenuItem<int?>(
                                          value: null,
                                          child: Text(''),
                                        ),
                                        ...List.generate(
                                          10,
                                          (i) => DropdownMenuItem<int?>(
                                            value: i + 1,
                                            child: Text('${i + 1}'),
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          player.phases[roundIndex] = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
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
