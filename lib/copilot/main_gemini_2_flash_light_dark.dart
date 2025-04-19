import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  static const int playerCount = 8;
  static const int roundCount = 12;

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
    (_) => List.generate(roundCount, (_) => ''),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            const DataColumn(label: Text('Player')),
            const DataColumn(label: Text('Total')),
            ...List.generate(roundCount,
                (index) => DataColumn(label: Text('Round ${index + 1}'))),
          ],
          rows: List.generate(playerCount, (playerIndex) {
            return DataRow(
              cells: [
                DataCell(
                  TextFormField(
                    controller: _playerNames[playerIndex],
                    decoration: const InputDecoration(hintText: 'Player Name'),
                  ),
                ),
                DataCell(Text(calculateTotal(playerIndex).toString())),
                ...List.generate(roundCount, (roundIndex) {
                  return DataCell(
                    Column(
                      children: [
                        TextFormField(
                          controller: _scores[playerIndex][roundIndex],
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
                        DropdownButtonFormField<String>(
                          value: _phases[playerIndex][roundIndex],
                          items: <String>[
                            '',
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
                              _phases[playerIndex][roundIndex] = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            );
          }),
        ),
      ),
    );
  }
}
