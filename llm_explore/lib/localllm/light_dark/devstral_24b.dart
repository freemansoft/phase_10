import 'package:flutter/material.dart';

void main() {
  runApp(Phase10ScoreKeeper());
}

class Phase10ScoreKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ScoreKeepingScreen(),
    );
  }
}

class ScoreKeepingScreen extends StatefulWidget {
  @override
  _ScoreKeepingScreenState createState() => _ScoreKeepingScreenState();
}

class _ScoreKeepingScreenState extends State<ScoreKeepingScreen> {
  final int maxPlayers = 8;
  final int maxRounds = 12;

  // List to hold player names and scores
  List<Map<String, dynamic>> players = List.generate(
    maxPlayers,
    (index) => {
      'name': 'Player ${index + 1}',
      'scores': [0] * maxRounds,
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Phase 10 Score Keeper')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 56.0,
          dataTextStyle: TextStyle(fontWeight: FontWeight.bold),
          columnSpacing: 24.0,
          columns: [
            DataColumn(label: Text('Player')),
            ...List.generate(
              maxRounds,
              (index) => DataColumn(label: Text('Round ${index + 1}')),
            ),
          ],
          rows: List<DataRow>.generate(maxPlayers, (playerIndex) {
            final player = players[playerIndex];
            return DataRow(
              cells: [
                DataCell(
                  TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      setState(() {
                        players[playerIndex]['name'] = value;
                      });
                    },
                  ),
                ),
                ...List.generate(maxRounds, (roundIndex) {
                  final score = player['scores'][roundIndex];
                  return DataCell(
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                players[playerIndex]['scores'][roundIndex] =
                                    int.parse(value);
                              });
                            },
                          ),
                        ),
                        DropdownButton<String>(
                          value: null, // Default value
                          items:
                              List.generate(
                                10 + 1,
                                (phaseNumber) =>
                                    phaseNumber == 0
                                        ? ''
                                        : '${phaseNumber + 1}',
                              ).map((value) {
                                return DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          onChanged: null,
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
    );
  }
}
