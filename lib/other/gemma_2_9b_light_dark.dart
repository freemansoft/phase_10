import 'package:flutter/material.dart';

void main() {
  runApp(const Phase10Scorekeeper());
}

class Phase10Scorekeeper extends StatelessWidget {
  const Phase10Scorekeeper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      themeMode: ThemeMode.light, // Default theme
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        // Customize dark theme colors and styles here
      ),
      home: const ScorekeeperScreen(),
    );
  }
}

class ScorekeeperScreen extends StatefulWidget {
  const ScorekeeperScreen({super.key});

  @override
  State<ScorekeeperScreen> createState() => _ScorekeeperScreenState();
}

class _ScorekeeperScreenState extends State<ScorekeeperScreen> {
  final List<Player> players = [
    Player(name: 'Player 1'),
    Player(name: 'Player 2'),
    Player(name: 'Player 3'),
    Player(name: 'Player 4'),
    Player(name: 'Player 5'),
    Player(name: 'Player 6'),
    Player(name: 'Player 7'),
    Player(name: 'Player 8'),
  ];

  int currentRound = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Scorekeeper'),
        actions: [
          Switch.adaptive(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              setState(() {
                ThemeMode mode = value ? ThemeMode.dark : ThemeMode.light;
                Navigator.pushReplacementNamed(context, '/');
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Player Name and Total Score Section
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(8.0),
              child: DataTable(
                columns: const [
                  DataColumn(
                      label: Text('Player',
                          style: TextStyle(
                              fontWeight: FontWeight.bold))), // Fixed Column
                  // ... Add columns for round scores and phases here
                ],
                rows: players.map((player) {
                  return DataRow(cells: [
                    DataCell(
                      Text(
                        '${player.name} - ${player.totalScore}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // ... Add cells for each round score and phase here
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Player {
  String name;
  int totalScore = 0;

  Player({required this.name});
}
