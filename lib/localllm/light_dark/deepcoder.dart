import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),
      home: Phase10Scorekeeper(),
    );
  }
}

class Phase10Scorekeeper extends StatefulWidget {
  _Phase10ScorekeeperState createState() => _Phase10ScorekeeperState();
}

class _Phase10ScorekeeperState extends State {
  bool _isDarkMode = false;
  List<Player> _players = [];

  @override
  void initState() {
    super.initState();
    // Initialize sample data
    _players = [
      Player(name: 'Player 1'),
      Player(name: 'Player 2'),
      // Add more players as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
        actions: <Widget>[
          Switch(
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
            },
          ),
        ],
      ),
      body: Theme(
        data: _isDarkMode ? ThemeData.dark() : ThemeData(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              // Player name editing section
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Player')),
                  ],
                  rows: _players.map((player) {
                    return DataRow(cells: [
                      DataCell(TextField(
                        initialValue:
                            TextEditingController(text: player.name).text,
                        onChanged: (value) => setState(() {
                          player.name = value;
                        }),
                      )),
                    ]);
                  }).toList(),
                ),
              ),

              // Score table
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Player')),
                    for (int i = 1; i <= 12; i++)
                      DataColumn(label: Text('Round $i')),
                  ],
                  rows: _players.map((player) {
                    return DataRow(cells: [
                      DataCell(Container(
                        width: 100,
                        child: Column(
                          children: <Widget>[
                            Text(player.name),
                            Text('Total: ${player.totalScore}'),
                          ],
                        ),
                      )),
                      for (int i = 0; i < 12; i++)
                        DataCell(Row(
                          children: [
                            Expanded(
                                child: TextField(
                                    // Add score input here
                                    )),
                            DropdownButton<String>(
                              items: [''] +
                                  List.generate(10, (i) => 'Phase ${i + 1}'),
                              onChanged: (value) {
                                // Handle phase selection
                              },
                            ),
                          ],
                        )),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Player {
  String name;
  List<Round> rounds;

  Player({this.name = '', this.rounds = const []});
}

class Round {
  double points;
  String phase;

  Round({this.points = 0.0, this.phase = ''});
}

// Add these helper functions if needed
double calculateTotalScore(Player player) {
  return player.rounds.fold(0.0, (sum, round) => sum + round.points);
}
