import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart'; // Import the package

void main() {
  runApp(const Phase10App());
}

class Phase10App extends StatefulWidget {
  const Phase10App({super.key});

  @override
  State<Phase10App> createState() => _Phase10AppState();
}

class _Phase10AppState extends State<Phase10App> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      home: ScoreboardScreen(onThemeToggle: toggleTheme),
    );
  }
}

class ScoreboardScreen extends StatefulWidget {
  final Function(bool) onThemeToggle;

  const ScoreboardScreen({super.key, required this.onThemeToggle});

  @override
  State<ScoreboardScreen> createState() => _ScoreboardScreenState();
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

  int calculateTotal(int playerIndex) {
    return _scores[playerIndex].fold(0, (sum, controller) {
      return sum + (int.tryParse(controller.text) ?? 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Scorekeeper'),
        actions: [
          Switch(
            value: _themeMode == ThemeMode.dark,
            onChanged: (bool newValue) {
              widget.onThemeToggle(newValue);
            },
          ),
        ],
      ),
      body: StickyHeadersTable(
        scrollDirection: ScrollDirection.both,
        columnsLength: roundCount + 2, // Player, Total, Rounds
        rowsLength: playerCount,
        columnsTitleHeight: 50,
        rowsTitleWidth: 150,
        contentCellWidth: 100,
        contentCellHeight: 100,
        legendCell: const Text('Player'),
        stickyLegendCell: true,
        titleCell: const Text('Total'),
        stickyTitleColumn: true,
        cellBuilder: (i, j) {
          if (j == 0) {
            // Player Name
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextFormField(
                  controller: _playerNames[i],
                  decoration: const InputDecoration(
                    hintText: 'Player Name',
                    border: InputBorder.none,
                  ),
                ),
              ),
            );
          } else if (j == 1) {
            // Total Score
            return Center(child: Text(calculateTotal(i).toString()));
          } else {
            // Round Scores and Phases
            int roundIndex = j - 2;
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: _scores[i][roundIndex],
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: const InputDecoration(
                        hintText: 'Score',
                        border: OutlineInputBorder(),
                        isDense: true,
                        contentPadding: EdgeInsets.all(8),
                      ),
                      onChanged: (value) {
                        setState(() {}); // Trigger rebuild to update total
                      },
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: _phases[i][roundIndex],
                    items: <String>[
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
                      '10'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    decoration: const InputDecoration(
                      hintText: 'Phase',
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.all(8),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        _phases[i][roundIndex] = newValue!;
                      });
                    },
                  ),
                ],
              ),
            );
          }
        },
        legendCellBuilder: (i) => Center(child: Text(_playerNames[i].text)),
        titleCellBuilder: (j) => Center(child: Text('Round ${j - 1}')),
      ),
    );
  }
}
