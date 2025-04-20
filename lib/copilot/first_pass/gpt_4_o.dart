import 'package:flutter/material.dart';

void main() {
  runApp(Phase10App());
}

class Phase10App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScoreKeeperScreen(),
    );
  }
}

class ScoreKeeperScreen extends StatefulWidget {
  @override
  _ScoreKeeperScreenState createState() => _ScoreKeeperScreenState();
}

class _ScoreKeeperScreenState extends State<ScoreKeeperScreen> {
  final int playerCount = 8;
  final int roundCount = 12;
  List<Map<String, dynamic>> players = [];

  @override
  void initState() {
    super.initState();
    players = List.generate(playerCount, (index) {
      return {
        'name': 'Player ${index + 1}',
        'scores': List.generate(roundCount, (_) => 0),
        'phases': List.generate(roundCount, (_) => ''),
      };
    });
  }

  int calculateTotalScore(List<int> scores) {
    return scores.reduce((a, b) => a + b);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Score Keeper'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Player')),
            DataColumn(label: Text('Total')),
            ...List.generate(roundCount, (roundIndex) {
              return DataColumn(label: Text('Round ${roundIndex + 1}'));
            }),
          ],
          rows: players.map((player) {
            return DataRow(cells: [
              DataCell(
                TextFormField(
                  initialValue: player['name'],
                  onChanged: (value) {
                    setState(() {
                      player['name'] = value;
                    });
                  },
                ),
              ),
              DataCell(Text(calculateTotalScore(player['scores']).toString())),
              ...List.generate(roundCount, (roundIndex) {
                return DataCell(
                  Column(
                    children: [
                      TextFormField(
                        initialValue: player['scores'][roundIndex].toString(),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            player['scores'][roundIndex] =
                                int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: player['phases'][roundIndex],
                        items: [
                          DropdownMenuItem(value: '', child: Text('')),
                          ...List.generate(10, (i) {
                            return DropdownMenuItem(
                              value: (i + 1).toString(),
                              child: Text((i + 1).toString()),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            player['phases'][roundIndex] = value ?? '';
                          });
                        },
                      ),
                    ],
                  ),
                );
              }),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
