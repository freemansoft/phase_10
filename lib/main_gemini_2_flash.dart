import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scorekeeper(),
    );
  }
}

class Scorekeeper extends StatefulWidget {
  @override
  _ScorekeeperState createState() => _ScorekeeperState();
}

class _ScorekeeperState extends State<Scorekeeper> {
  List<Player> players =
      List.generate(8, (index) => Player(name: 'Player ${index + 1}'));
  int numberOfRounds = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: _buildColumns(),
          rows: _buildRows(),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    List<DataColumn> columns = [
      DataColumn(label: Text('Player')),
      DataColumn(label: Text('Total')),
      ...List.generate(
        numberOfRounds,
        (index) => DataColumn(label: Text('Round ${index + 1}')),
      ),
    ];
    return columns;
  }

  List<DataRow> _buildRows() {
    return players.map((player) => _buildRow(player)).toList();
  }

  DataRow _buildRow(Player player) {
    return DataRow(
      cells: [
        DataCell(
          TextFormField(
            initialValue: player.name,
            onChanged: (value) {
              setState(() {
                player.name = value;
              });
            },
          ),
        ),
        DataCell(Text(player.totalScore.toString())),
        ...List.generate(numberOfRounds, (roundIndex) {
          return DataCell(
            Column(
              children: [
                SizedBox(
                  width: 75,
                  height: 50,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: 'Score'),
                    onChanged: (value) {
                      setState(() {
                        player.roundScores[roundIndex] =
                            int.tryParse(value) ?? 0;
                        player.calculateTotalScore();
                      });
                    },
                  ),
                ),
                DropdownButton<int>(
                  value: player.completedPhases[roundIndex],
                  hint: Text('Phase'),
                  items: [
                    DropdownMenuItem(
                      child: Text('None'),
                      value: null,
                    ),
                    ...List.generate(
                      10,
                      (phaseIndex) => DropdownMenuItem(
                        child: Text('${phaseIndex + 1}'),
                        value: phaseIndex + 1,
                      ),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      player.completedPhases[roundIndex] = value;
                    });
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class Player {
  String name;
  List<int?> completedPhases = List.generate(12, (index) => null);
  List<int> roundScores = List.generate(12, (index) => 0);
  int totalScore = 0;

  Player({required this.name});

  void calculateTotalScore() {
    totalScore = roundScores.fold(0, (sum, score) => sum + score);
  }
}
