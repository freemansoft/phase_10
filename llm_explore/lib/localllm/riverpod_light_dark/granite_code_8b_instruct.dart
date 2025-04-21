import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Scorekeeper',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Phase10ScoreKeeper(),
    );
  }
}

class Phase10ScoreKeeper extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = [
      'Player 1',
      'Player 2',
      'Player 3',
      'Player 4',
    ]; // Add more players as needed
    return Scaffold(
      appBar: AppBar(title: Text('Phase 10 Scorekeeper')),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: const EdgeInsets.symmetric(horizontal: 8.0),
          columns: [
            DataColumn(label: Text('Player')),
            for (var i = 1; i <= 12; i++) ...[
              DataColumn(label: Text('Round $i')),
              DataColumn(label: Text('Phase $i')),
            ],
          ],
          rows: [
            for (var player in players) ...[
              DataRow(
                cells: [
                  DataCell(Text(player)),
                  for (var i = 1; i <= 12; i++) ...[
                    DataCell(
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    DataCell(
                      DropdownButtonFormField<int>(
                        items: [
                          DropdownMenuItem<int>(
                            value: null,
                            child: Text('Select Phase'),
                          ),
                          for (var j = 1; j <= 10; j++) ...[
                            DropdownMenuItem<int>(value: j, child: Text('$j')),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
