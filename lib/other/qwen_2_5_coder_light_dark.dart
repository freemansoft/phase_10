import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Phase10Scorekeeper(),
    );
  }
}

class Phase10Scorekeeper extends StatefulWidget {
  @override
  _Phase10ScorekeeperState createState() => _Phase10ScorekeeperState();
}

class _Phase10ScorekeeperState extends State<Phase10Scorekeeper> {
  List<String> playerNames = List.generate(8, (index) => 'Player ${index + 1}');
  List<List<int>> roundScores = List.generate(8, (_) => List.filled(12, 0));
  List<String?> phaseCompleted = List.filled(8 * 12, null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
        actions: [
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              setState(() {
                if (value) {
                  Theme.of(context).brightness == Brightness.dark;
                } else {
                  Theme.of(context).brightness == Brightness.light;
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultColumnWidth: FixedColumnWidth(100.0),
          columnWidths: {
            0: FixedColumnWidth(200.0),
            ...Map<int, ColumnWidth>.fromIterable(range(1, 13), (index) => [index + 1]: FixedColumnWidth(150.0)),
          },
          children: [
            TableRow(
              children: [
                _buildHeaderCell('Player Name'),
                ...List.generate(12, (_) => _buildHeaderCell('Round')),
              ],
            ),
            ...playerNames.asMap().map((index, name) {
              return MapEntry(index, TableRow(
                children: [
                  _buildEditableCell(name, (newName) {
                    setState(() {
                      playerNames[index] = newName;
                    });
                  }),
                  ...roundScores[index].asMap().map((roundIndex, score) {
                    return MapEntry(roundIndex, Column(
                      children: [
                        _buildNumericInput(score, (newScore) {
                          setState(() {
                            roundScores[index][roundIndex] = newScore;
                          });
                        }),
                        DropdownButton<String>(
                          value: phaseCompleted[index * 12 + roundIndex],
                          onChanged: (newValue) {
                            setState(() {
                              phaseCompleted[index * 12 + roundIndex] = newValue;
                            });
                          },
                          items: [null, ...List<int>.generate(10, (i) => i + 1).map((i) => i.toString())].map<DropdownMenuItem<String>>((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value ?? 'None'),
                            );
                          }).toList(),
                        ),
                      ],
                    ));
                  }).values.toList(),
                ],
              ));
            }).values.toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String text) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      ),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildEditableCell(String text, Function(String) onChanged) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: TextEditingController(text: text),
        onChanged: onChanged,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildNumericInput(int value, Function(int) onChanged) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: TextEditingController(text: value.toString()),
        keyboardType: TextInputType.number,
        onChanged: (text) {
          if (text.isNotEmpty) {
            int? newValue = int.tryParse(text);
            if (newValue != null) {
              onChanged(newValue);
            }
          } else {
            onChanged(0);
          }
        },
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}