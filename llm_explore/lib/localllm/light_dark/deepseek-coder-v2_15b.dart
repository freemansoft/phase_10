import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      themeMode:
          ThemeMode.system, // Use system theme mode for light and dark themes
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: Phase10ScoreKeeper(),
    );
  }
}

class Phase10ScoreKeeper extends StatefulWidget {
  @override
  _Phase10ScoreKeeperState createState() => _Phase10ScoreKeeperState();
}

class _Phase10ScoreKeeperState extends State<Phase10ScoreKeeper> {
  final List<Player> players = List.generate(
      8,
      (index) => Player(
          name: 'Player ${index + 1}', scores: List.filled(12, RoundScore())));
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Score Keeper'),
        actions: [
          Switch(
            value: isDarkMode,
            onChanged: (value) {
              setState(() {
                isDarkMode = value;
              });
            },
          ),
        ],
      ),
      body: Container(
        child: Table(
          columnWidths: const <int, TableColumnWidth>{
            0: IntrinsicColumnWidth(), // Player name and total score column
            1: FlexColumnWidth(), // Round scores columns
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.grey[200]),
              cells: [
                Center(
                    child: Text('Player Name',
                        style: TextStyle(fontWeight: FontWeight.bold))),
                for (int i = 1; i <= 12; i++)
                  Center(
                      child: Text('Round $i',
                          style: TextStyle(fontWeight: FontWeight.bold)))
              ],
            ),
            for (var player in players)
              TableRow(
                children: [
                  EditableText(
                    text: TextSpan(
                        text: player.name,
                        recognizer: TapGestureRecognizer()..onTap = () {}),
                    onSubmitted: (value) => setState(() => player.name = value),
                  ),
                  for (var score in player.scores)
                    TableCell(
                        child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: 'Score'),
                      onChanged: (value) {
                        setState(() {
                          if (value != null && value.isNotEmpty)
                            score.score = int.parse(value);
                        });
                      },
                    )),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class Player {
  String name;
  List<RoundScore> scores;

  Player({required this.name, required this.scores});
}

class RoundScore {
  int score = 0;
  int phaseCompleted =
      0; // Assuming 1 through 10 for phases, and 0 for not completed

  RoundScore();
}
