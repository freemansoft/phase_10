import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_table_2/data_table_2.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(),
    );
  }
}

// State management using Riverpod
final playersProvider = StateNotifierProvider<PlayersNotifier, Map<String, dynamic>>((ref) {
  return PlayersNotifier();
});

class PlayersNotifier extends StateNotifier<Map<String, dynamic>> {
  PlayersNotifier() : super({
    'players': List.generate(8, (i) => {'name': 'Player ${i+1}', 'scores': [0.0]*12}),
    'currentRound': 0,
    'isDarkMode': false
  });

  void updateScore(String playerId, int roundIndex, double score) {
    state['players'] = state['players'].map((player) {
      if (player['_id'] == playerId) {
        var scores = player['scores'].toList();
        scores[roundIndex] = score;
        return {...player, 'scores': scores};
      }
      return player;
    }).toList();
  }

  void toggleTheme() {
    state['isDarkMode'] = !state['isDarkMode'];
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ProviderScope.containerOf(context).read(playersProvider.notifier)['isDarkMode'];
    final players = ProviderScope.containerOf(context).read(playersProvider.notifier)['players'] as List;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Scorekeeper'),
        actions: [
          ThemeSwitcher(
            onChanged: (theme) {
              if (theme == ThemeMode.dark) {
                ProviderScope.containerOf(context).read(playersProvider.notifier).toggleTheme();
              }
            },
            currentTheme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
          columnSpacing: 20,
          headerHeight: 50,
          columns: [
            DataColumn2(
              width: 80,
              child: Text('Player'),
            ),
            ...List.generate(12, (i) => DataColumn2(child: Text('${i+1}')))
          ],
          rows: players.map<DataRow>((player) {
            final scores = player['scores'] as List<double>;

            return DataRow(cells: [
              DataCell(
                Column(children: [
                  TextFormField(
                    initialValue: player['name'],
                    onChanged: (value) {
                      ProviderScope.containerOf(context).read(playersProvider.notifier).state['players'].forEach((p) {
                        if (p['_id'] == player['_id']) {
                          p['name'] = value;
                        }
                      });
                    },
                  ),
                  Text('${scores.reduce((a, b) => a + b)}')
                ]),
              ),
              ...List.generate(12, (i) {
                return DataCell(
                  Column(children: [
                    TextFormField(
                      initialValue: scores[i].toString(),
                      onChanged: (value) {
                        ProviderScope.containerOf(context).read(playersProvider.notifier)
                            .updateScore(player['_id'], i, double.tryParse(value) ?? 0);
                      },
                    ),
                    DropdownButton<String>(
                      value: 'Phase ${i+1}',
                      items: <String>['', '1', '2', ..., '10']
                        .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        )).toList(),
                      onChanged: (value) {
                        // Handle phase selection
                      },
                    )
                  ]),
                );
              })
            ]);
          }).toList(),
        ),
      ),
    );
  }
}