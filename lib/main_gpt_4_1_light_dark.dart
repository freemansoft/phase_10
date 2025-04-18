import 'package:flutter/material.dart';

void main() {
  runApp(const Phase10App());
}

class Phase10App extends StatefulWidget {
  const Phase10App({Key? key}) : super(key: key);

  @override
  State<Phase10App> createState() => _Phase10AppState();
}

class _Phase10AppState extends State<Phase10App> {
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: Phase10ScorePage(
        darkMode: _darkMode,
        onThemeChanged: (v) => setState(() => _darkMode = v),
      ),
    );
  }
}

class Phase10ScorePage extends StatefulWidget {
  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  const Phase10ScorePage({
    Key? key,
    required this.darkMode,
    required this.onThemeChanged,
  }) : super(key: key);

  @override
  State<Phase10ScorePage> createState() => _Phase10ScorePageState();
}

class _Phase10ScorePageState extends State<Phase10ScorePage> {
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

  final List<TextEditingController> _nameControllers = List.generate(
    playerCount,
    (i) => TextEditingController(text: 'Player ${i + 1}'),
  );

  final List<List<TextEditingController>> _scoreControllers = List.generate(
    playerCount,
    (_) => List.generate(roundCount, (_) => TextEditingController(text: '0')),
  );

  final List<List<String>> _phaseSelections = List.generate(
    playerCount,
    (_) => List.generate(roundCount, (_) => ''),
  );

  int _getPlayerTotal(int playerIdx) {
    int total = 0;
    for (var ctrl in _scoreControllers[playerIdx]) {
      total += int.tryParse(ctrl.text) ?? 0;
    }
    return total;
  }

  @override
  void dispose() {
    for (var ctrl in _nameControllers) {
      ctrl.dispose();
    }
    for (var row in _scoreControllers) {
      for (var ctrl in row) {
        ctrl.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a horizontal scroll view for the table, freeze the first column
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Scorekeeper'),
        actions: [
          Row(
            children: [
              const Icon(Icons.light_mode),
              Switch(
                value: widget.darkMode,
                onChanged: widget.onThemeChanged,
              ),
              const Icon(Icons.dark_mode),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Fixed first column
                Column(
                  children: [
                    // Header
                    Container(
                      width: 140,
                      height: 56,
                      alignment: Alignment.center,
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.1),
                      child: const Text(
                        'Player / Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Player rows
                    for (int p = 0; p < playerCount; p++)
                      Container(
                        width: 140,
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
                            // Editable player name
                            SizedBox(
                              width: 80,
                              child: TextField(
                                controller: _nameControllers[p],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            // Total score
                            SizedBox(
                              width: 60,
                              child: Text(
                                _getPlayerTotal(p).toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                // Scrollable rounds columns
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 56,
                      dataRowHeight: 56,
                      columns: [
                        for (int r = 0; r < roundCount; r++)
                          DataColumn(
                            label: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Round ${r + 1}',
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
                        for (int p = 0; p < playerCount; p++)
                          DataRow(
                            cells: [
                              for (int r = 0; r < roundCount; r++)
                                DataCell(
                                  Row(
                                    children: [
                                      // Score input
                                      SizedBox(
                                        width: 40,
                                        child: TextField(
                                          controller: _scoreControllers[p][r],
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            isDense: true,
                                            hintText: '0',
                                          ),
                                          onChanged: (_) => setState(() {}),
                                        ),
                                      ),
                                      // Phase dropdown
                                      SizedBox(
                                        width: 40,
                                        child: DropdownButton<String>(
                                          value: _phaseSelections[p][r],
                                          isDense: true,
                                          isExpanded: true,
                                          underline: const SizedBox(),
                                          items: phaseOptions
                                              .map((v) => DropdownMenuItem(
                                                    value: v,
                                                    child: Text(
                                                        v.isEmpty ? '-' : v),
                                                  ))
                                              .toList(),
                                          onChanged: (v) {
                                            setState(() {
                                              _phaseSelections[p][r] = v ?? '';
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
          );
        },
      ),
    );
  }
}
