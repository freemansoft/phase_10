import 'package:flutter/material.dart';
import 'package:flutter_tables/flutter_tables.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData(brightness: Brightness.light),
      home: Phase10Scorekeeper(),
    );
  }
}

enum Phase { none, one, two, three, four, five, six, seven, eight, nine, ten }

class Phase10Scorekeeper extends StatefulWidget {
  @override
  _Phase10ScorekeeperState createState() => _Phase10ScorekeeperState();
}

class _Phase10ScorekeeperState extends State<Phase10Scorekeeper> {
  final List<String> _playerNames = List.generate(8, (i) => 'Player ${i + 1}');
  final List<List<int>> _roundScores =
      List.generate(8, (_) => List.filled(12, 0));
  bool _isDarkMode = false;

  void _updateRoundScore(int playerIndex, int roundIndex, int score) {
    setState(() {
      _roundScores[playerIndex][roundIndex] = score;
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
        actions: [
          Switch(
            value: _isDarkMode,
            onChanged: _toggleTheme,
          ),
        ],
      ),
      body: Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: FixedColumnWidth(150),
        },
        children: List.generate(
          _playerNames.length,
          (playerIndex) => [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _playerNames[playerIndex] = value;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Player Name'),
                        initialValue: _playerNames[playerIndex],
                      ),
                      Text(
                        'Total Score: ${_roundScores[playerIndex].reduce((a, b) => a + b)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ...List.generate(
              12,
              (roundIndex) => TableRow(
                children: [
                  Text('Round ${roundIndex + 1}'),
                  DropdownButton<Phase>(
                    value: _roundScores[playerIndex][roundIndex] == 0
                        ? Phase.none
                        : Phase.values[_roundScores[playerIndex][roundIndex]],
                    onChanged: (newValue) {
                      setState(() {
                        if (_roundScores[playerIndex][roundIndex] > 0 &&
                            newValue != null &&
                            newValue.index <
                                _roundScores[playerIndex][roundIndex]) {
                          _roundScores[playerIndex][roundIndex] =
                              newValue.index;
                        }
                      });
                    },
                    items: Phase.values.map((phase) => DropdownMenuItem(
                          value: phase,
                          child: Text(phase.toString().split('.').last),
                        )),
                  ),
                  TextField(
                    onChanged: (value) {
                      _updateRoundScore(
                          playerIndex, roundIndex, int.tryParse(value) ?? 0);
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Score'),
                    initialValue: '${_roundScores[playerIndex][roundIndex]}',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
