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
  bool isDarkMode = false;

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
          Row(
            children: [
              const Text('Dark Mode'),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    widget.onThemeToggle(value);
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed first column
            Column(
              children: [
                // Header
                Container(
                  height: 56,
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: const Row(
                    children: [
                      SizedBox(width: 120, child: Text('Player')),
                      SizedBox(width: 80, child: Text('Total')),
                    ],
                  ),
                ),
                // Player rows
                ...List.generate(playerCount, (playerIndex) {
                  return Container(
                    height: 56,
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120,
                          child: TextField(
                            controller: _playerNames[playerIndex],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 80,
                          child: Text(
                            calculateTotal(playerIndex).toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            // Scrollable rounds columns
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: [
                  // Round headers
                  Row(
                    children: List.generate(roundCount, (roundIndex) {
                      return Container(
                        width: 160,
                        height: 56,
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.center,
                        child: Text('Round ${roundIndex + 1}'),
                      );
                    }),
                  ),
                  // Score and phase rows
                  ...List.generate(playerCount, (playerIndex) {
                    return Row(
                      children: List.generate(roundCount, (roundIndex) {
                        return Container(
                          width: 160,
                          height: 56,
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: TextField(
                                  controller: _scores[playerIndex][roundIndex],
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Score',
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: DropdownButton<String>(
                                  value: _phases[playerIndex][roundIndex],
                                  isExpanded: true,
                                  items: [
                                    '',
                                    ...List.generate(10, (i) => '${i + 1}')
                                  ].map((phase) {
                                    return DropdownMenuItem(
                                      value: phase,
                                      child: Text(phase),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _phases[playerIndex][roundIndex] = value!;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _playerNames) {
      controller.dispose();
    }
    for (var row in _scores) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}
