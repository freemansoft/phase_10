import 'package:flutter/material.dart';

void main() {
  runApp(const Phase10App());
}

class Phase10App extends StatelessWidget {
  const Phase10App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const ScoreKeeperPage(),
    );
  }
}

class ScoreKeeperPage extends StatefulWidget {
  const ScoreKeeperPage({Key? key}) : super(key: key);

  @override
  State<ScoreKeeperPage> createState() => _ScoreKeeperPageState();
}

class _ScoreKeeperPageState extends State<ScoreKeeperPage> {
  bool _isDarkMode = false;
  static const int playerCount = 8;
  static const int roundCount = 12;
  static const List<String> phaseOptions = [
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
  ];

  final List<TextEditingController> _playerNames = List.generate(
    playerCount,
    (index) => TextEditingController(text: 'Player ${index + 1}'),
  );

  final List<List<TextEditingController>> _scores = List.generate(
    playerCount,
    (_) => List.generate(roundCount, (_) => TextEditingController(text: '0')),
  );

  final List<List<String>> _phases = List.generate(
    playerCount,
    (_) => List.generate(roundCount, (_) => ''),
  );

  int _calculateTotalScore(int playerIndex) {
    return _scores[playerIndex]
        .map((controller) => int.tryParse(controller.text) ?? 0)
        .reduce((a, b) => a + b);
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
                value: _isDarkMode,
                onChanged: (value) {
                  setState(() {
                    _isDarkMode = value;
                  });
                },
              ),
              const Icon(Icons.dark_mode),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Fixed first column
            Column(
              children: [
                Container(
                  width: 140,
                  height: 56,
                  alignment: Alignment.center,
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  child: const Text(
                    'Player / Total',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                for (int i = 0; i < playerCount; i++)
                  Container(
                    width: 140,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Theme.of(context).dividerColor),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _playerNames[i],
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: Text(
                            _calculateTotalScore(i).toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            // Scrollable rounds
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 56,
                  dataRowHeight: 56,
                  columns: [
                    for (int round = 0; round < roundCount; round++)
                      DataColumn(
                        label: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Round ${round + 1}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('Score / Phase',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                  ],
                  rows: [
                    for (int player = 0; player < playerCount; player++)
                      DataRow(
                        cells: [
                          for (int round = 0; round < roundCount; round++)
                            DataCell(
                              Row(
                                children: [
                                  SizedBox(
                                    width: 40,
                                    child: TextField(
                                      controller: _scores[player][round],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        isDense: true,
                                        hintText: '0',
                                      ),
                                      onChanged: (_) => setState(() {}),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                    child: DropdownButton<String>(
                                      value: _phases[player][round],
                                      isDense: true,
                                      isExpanded: true,
                                      underline: const SizedBox(),
                                      items: phaseOptions
                                          .map((value) => DropdownMenuItem(
                                                value: value,
                                                child: Text(value.isEmpty
                                                    ? '-'
                                                    : value),
                                              ))
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _phases[player][round] = value ?? '';
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
