import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: isDark
          ? ThemeData.dark().copyWith(textTheme: TextTheme())
          : ThemeData(),
      home: Phase10Scorekeeper(),
    );
  }
}

class Phase10Scorekeeper extends StatefulWidget {
  @override
  _Phase10ScorekeeperState createState() => _Phase10ScorekeeperState();
}

class _Phase10ScorekeeperState extends State<Phase10Scorekeeper> {
  final List<String> players = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Player 5',
    'Player 6',
    'Player 7',
    'Player 8'
  ];

  Map<String, int> playerScores = {};
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    // Initialize scores for all players
    for (var player in players) {
      playerScores[player] = 0;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => isDarkMode = !isDarkMode),
          ),
        ],
      ),
      body: Container(
        child: Theme(
          data: isDarkMode ? ThemeData.dark() : ThemeData(),
          child: _buildScoreTable(),
        ),
      ),
    );
  }

  Widget _buildScoreTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Player')),
          DataColumn(label: Text('Total')),
          for (var i = 1; i <= 12; i++) DataColumn(label: Text('Round $i')),
        ],
        rows: players.map((player) {
          return DataRow(cells: [
            DataCell(EditableText(
              controller: TextEditingController(),
              onEditingComplete: () => setState(() {}),
              text: player,
            )),
            DataCell(Center(child: Text(playerScores[player].toString()))),
            for (var i = 1; i <= 12; i++)
              DataCell(Center(
                  child: TextFormField(
                initialValue: '0',
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) {
                  setState(() {
                    playerScores[player] += int.parse(value);
                  });
                },
              ))),
          ]);
        }).toList(),
      ),
    );
  }
}
