import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Score Keeper',
      theme: ThemeData(primarySwatch: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ScoreboardScreen(),
    );
  }
}

class ScoreboardScreen extends StatefulWidget {
  const ScoreboardScreen({Key? key}) : super(key: key);

  @override
  _ScoreboardScreenState createState() => _ScoreboardScreenState();
}

class _ScoreboardScreenState extends State<ScoreboardScreen> {
  static const int playerCount = 6; // Changed to 6 players
  static const int roundCount = 10; // Changed to 10 rounds

  final List<TextEditingController> _playerNames = List.generate(
    playerCount,
    (index) => TextEditingController(text: 'Player ${index + 1}'),
  );

  final List<List<TextEditingController>> _scores = List.generate(
    playerCount,
    (_) => List.generate(roundCount, (_) => TextEditingController()),
  );

  final List<List<String>> _phases = List.generate(
    playerCount,
    (_) => List.generate(roundCount, (_) => 'N/A'), // Default to "N/A"
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Score Keeper'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              // Toggle theme mode
            },
          ),
        ],
      ),
      body: StickyHeadersTable(
        scrollDirection: ScrollDirection.horizontal,
        columnsLength: roundCount,
        rowsLength: playerCount,
        columnsTitleHeight: 50,
        rowsTitleWidth: 150,
        contentCellWidth: 80,
        cellHeight: 50,
        columnsTitleBuilder:
            (i) => Text(
              'Round ${i + 1}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        rowsTitleBuilder: (i) {
          int totalScore = 0;
          for (var scoreController in _scores[i]) {
            if (scoreController.text.isNotEmpty) {
              totalScore += int.tryParse(scoreController.text) ?? 0;
            }
          }
          return Row(
            children: [
              SizedBox(
                width: 100,
                child: TextFormField(
                  controller: _playerNames[i],
                  decoration: const InputDecoration(labelText: 'Player Name'),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Total: $totalScore',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
        contentCellBuilder:
            (i, j) => Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 70,
                    height: 25,
                    child: TextFormField(
                      controller: _scores[j][i],
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ),
                  DropdownButton<String>(
                    value: _phases[j][i],
                    items:
                        <String>[
                          'N/A',
                          '1',
                          '2',
                          '3',
                          '4',
                          '5',
                          '6',
                          '7',
                          '8',
                          '9',
                          '10',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _phases[j][i] = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
