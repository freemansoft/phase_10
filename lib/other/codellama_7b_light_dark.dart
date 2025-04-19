import 'package:flutter/material.dart';

class Scorekeeper extends StatefulWidget {
  @override
  _ScorekeeperState createState() => _ScorekeeperState();
}

class _ScorekeeperState extends State<Scorekeeper> {
  List<Player> players = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
        actions: [
          SwitchListTile(
            value: false,
            onChanged: (value) {},
            secondary: Icon(Icons.lightbulb_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: players.map((player) {
            return ListTile(
              title: Text('${player.name}'),
              subtitle: Text('Total Score: ${player.totalScore}'),
              trailing: DropdownButton<int>(
                value: player.phaseCompleted,
                onChanged: (newValue) {
                  setState(() {
                    player.phaseCompleted = newValue;
                  });
                },
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('No Phase Completed'),
                  ),
                  ...List<int>.generate(10, (index) {
                    return DropdownMenuItem(
                      value: index + 1,
                      child: Text('Phase ${index + 1}'),
                    );
                  }),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class Player {
  String name;
  int totalScore;
  int phaseCompleted;

  Player(
      {required this.name,
      required this.totalScore,
      required this.phaseCompleted});
}
