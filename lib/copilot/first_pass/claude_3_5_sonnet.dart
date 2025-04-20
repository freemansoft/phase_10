import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
        primarySwatch: Colors.blue,
      ),
      home: const ScoreKeeperPage(),
    );
  }
}

class PlayerScore {
  String name;
  List<int?> scores;
  List<int?> phases;

  PlayerScore({
    required this.name,
    required int rounds,
  })  : scores = List.filled(rounds, null),
        phases = List.filled(rounds, null);

  int get total => scores.fold(0, (sum, score) => sum + (score ?? 0));
}

class ScoreKeeperPage extends StatefulWidget {
  const ScoreKeeperPage({super.key});

  @override
  State<ScoreKeeperPage> createState() => _ScoreKeeperPageState();
}

class _ScoreKeeperPageState extends State<ScoreKeeperPage> {
  static const int playerCount = 8;
  static const int roundCount = 12;
  final List<PlayerScore> players = List.generate(
    playerCount,
    (index) => PlayerScore(
      name: 'Player ${index + 1}',
      rounds: roundCount,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Score Keeper'),
      ),
      body: SingleChildScrollView(
        child: Row(
          children: [
            // Fixed first column
            Column(
              children: [
                // Header
                Container(
                  height: 56,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.grey[200],
                  ),
                  child: const Text(
                    'Player / Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                // Player names and totals
                ...players.map((player) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                      ),
                      width: 150,
                      child: Column(
                        children: [
                          TextField(
                            controller:
                                TextEditingController(text: player.name),
                            onChanged: (value) {
                              setState(() => player.name = value);
                            },
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(vertical: 8),
                            ),
                          ),
                          Text(
                            'Total: ${player.total}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            // Scrollable rounds columns
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  children: [
                    // Round headers
                    Row(
                      children: List.generate(
                        roundCount,
                        (index) => Container(
                          width: 120,
                          height: 56,
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            color: Colors.grey[200],
                          ),
                          child: Text(
                            'Round ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    // Player rounds
                    ...List.generate(
                      playerCount,
                      (playerIndex) => Row(
                        children: List.generate(
                          roundCount,
                          (roundIndex) => Container(
                            width: 120,
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Column(
                              children: [
                                TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    isDense: true,
                                    contentPadding:
                                        EdgeInsets.symmetric(vertical: 8),
                                    hintText: 'Score',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      players[playerIndex].scores[roundIndex] =
                                          int.tryParse(value);
                                    });
                                  },
                                ),
                                DropdownButton<int?>(
                                  value:
                                      players[playerIndex].phases[roundIndex],
                                  hint: const Text('Phase'),
                                  isExpanded: true,
                                  items: [
                                    const DropdownMenuItem<int?>(
                                      value: null,
                                      child: Text(''),
                                    ),
                                    ...List.generate(
                                      10,
                                      (index) => DropdownMenuItem<int?>(
                                        value: index + 1,
                                        child: Text('${index + 1}'),
                                      ),
                                    )
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      players[playerIndex].phases[roundIndex] =
                                          value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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
