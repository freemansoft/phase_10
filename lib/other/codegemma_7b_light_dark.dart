import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: const Phase10Scorekeeper(),
    );
  }
}

class Phase10Scorekeeper extends StatefulWidget {
  const Phase10Scorekeeper({super.key});

  @override
  State<Phase10Scorekeeper> createState() => _Phase10ScorekeeperState();
}

class _Phase10ScorekeeperState extends State<Phase10Scorekeeper> {
  List<String> players = [
    'Player 1',
    'Player 2',
    'Player 3',
    'Player 4',
    'Player 5',
    'Player 6',
    'Player 7',
    'Player 8'
  ];
  List<int> roundScores = List.filled(8, 0);
  List<int> totalScores = List.filled(8, 0);
  List<String> phases = [
    'None',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Scorekeeper'),
        actions: [
          Switch(
            value: Theme.of(context).brightness == Brightness.dark,
            onChanged: (value) {
              setState(() {
                Theme.of(context).brightness =
                    value ? Brightness.dark : Brightness.light;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
              label: Text('Player'),
              numeric: false,
            ),
            DataColumn(
              label: Text('Total'),
              numeric: true,
            ),
            ...List.generate(
                12, (index) => DataColumn(label: Text('Round ${index + 1}'))),
          ],
          rows: players.map((player) {
            return DataRow(
              cells: [
                DataCell(
                  TextField(
                    initialValue: player,
                    onChanged: (value) {
                      setState(() {
                        players[players.indexOf(player)] = value;
                      });
                    },
                  ),
                ),
                DataCell(Text('${totalScores[players.indexOf(player)]}')),
                ...roundScores.map((score) => DataCell(
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            totalScores[players.indexOf(player)] +=
                                int.parse(value);
                          });
                        },
                      ),
                    )),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
