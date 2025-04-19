import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences.dart';

void main() {
  runApp(const Phase10App());
}

class Phase10App extends StatefulWidget {
  const Phase10App({super.key});

  @override
  State<Phase10App> createState() => _Phase10AppState();
}

class _Phase10AppState extends State<Phase10App> {
  ThemeMode _themeMode = ThemeMode.system;

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
              const Icon(Icons.light_mode),
              Switch(
                value: isDarkMode,
                onChanged: (value) {
                  setState(() {
                    isDarkMode = value;
                    widget.onThemeToggle(value);
                  });
                },
              ),
              const Icon(Icons.dark_mode),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed first column
            SizedBox(
              width: 150,
              child: Column(
                children: [
                  Container(
                    height: 56,
                    alignment: Alignment.center,
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: const Text(
                      'Player / Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...List.generate(playerCount, (playerIndex) {
                    return Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).dividerColor),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _playerNames[playerIndex],
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          Text(
                            calculateTotal(playerIndex).toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            // Scrollable rounds section
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: roundCount * 120.0,
                  child: Column(
                    children: [
                      // Header row
                      Row(
                        children: List.generate(
                          roundCount,
                          (index) => Container(
                            width: 120,
                            height: 56,
                            alignment: Alignment.center,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            child: Text(
                              'Round ${index + 1}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      // Player rows
                      ...List.generate(
                        playerCount,
                        (playerIndex) => Row(
                          children: List.generate(
                            roundCount,
                            (roundIndex) => Container(
                              width: 120,
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Score input
                                  SizedBox(
                                    width: 60,
                                    child: TextField(
                                      controller: _scores[playerIndex]
                                          [roundIndex],
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.symmetric(horizontal: 8),
                                        hintText: '0',
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  // Phase dropdown
                                  SizedBox(
                                    width: 60,
                                    child: DropdownButton<String>(
                                      value: _phases[playerIndex][roundIndex],
                                      isExpanded: true,
                                      icon: const Icon(Icons.arrow_drop_down),
                                      underline: Container(),
                                      items: [
                                        const DropdownMenuItem(
                                          value: '',
                                          child: Text('-'),
                                        ),
                                        ...List.generate(
                                          10,
                                          (i) => DropdownMenuItem(
                                            value: (i + 1).toString(),
                                            child: Text((i + 1).toString()),
                                          ),
                                        ),
                                      ],
                                      onChanged: (String? value) {
                                        setState(() {
                                          _phases[playerIndex][roundIndex] =
                                              value ?? '';
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
