import 'package:flutter/material.dart';

void main() {
  runApp(PhaseTenScoreKeeper());
}

class PhaseTenScoreKeeper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScoreKeeperHomePage(title: 'Phase 10 Score Keeping'),
    );
  }
}

class ScoreKeeperHomePage extends StatefulWidget {
  ScoreKeeperHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _ScoreKeeperHomePageState createState() => _ScoreKeeperHomePageState();
}

class _ScoreKeeperHomePageState extends State<ScoreKeeperHomePage> {
  List<Player> players = List.generate(8, (index) => Player(name: "Player ${index + 1}"));
  final int rounds = 12;
  final phases = ["", "Phase 1", "Phase 2", "Phase 3", "Phase 4", "Phase 5", "Phase 6", "Phase 7", "Phase 8", "Phase 9", "Phase 10"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {0: FixedColumnWidth(150.0), 1: FixedColumnWidth(60.0)},
              border: TableBorder.all(),
              children: [
                TableRow(
                  children: [
                    TableCell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Player Name / Total Score', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    for (int i = 0; i < rounds; i++)
                      TableCell(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text('Round ${i + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('Score', style: TextStyle(fontSize: 10)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text('Phase', style: TextStyle(fontSize: 10)),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                for (int playerIndex = 0; playerIndex < players.length; playerIndex++)
                  TableRow(
                    children: [
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.middle,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration: InputDecoration(labelText: 'Name'),
                                onChanged: (value) {
                                  setState(() {
                                    players[playerIndex].name = value;
                                  });
                                },
                                controller: TextEditingController(text: players[playerIndex].name),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Total: ${players[playerIndex].calculateTotalScore()}'),
                            ),
                          ],
                        ),
                      ),
                      for (int round = 0; round < rounds; round++)
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(labelText: 'Score'),
                                  onChanged: (value) {
                                    setState(() {
                                      players[playerIndex].rounds[round].score = int.tryParse(value) ?? 0;
                                    });
                                  },
                                  controller: TextEditingController(text: players[playerIndex].rounds[round].score.toString()),
                                ),
                                DropdownButtonFormField<String>(
                                  decoration: InputDecoration(labelText: 'Phase'),
                                  items: phases.map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      players[playerIndex].rounds[round].phase = value ?? "";
                                    });
                                  },
                                  value: players[playerIndex].rounds[round].phase,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
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
  List<Round> rounds;

  Player({required this.name}) : rounds = List.generate(12, (_) => Round());

  int calculateTotalScore() {
    return rounds.fold(0, (total, round) => total + round.score);
  }
}

class Round {
  int score;
  String phase;

  Round({this.score = 0, this.phase = ""});
}