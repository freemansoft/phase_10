import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Phase 10 Sandbox',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phase 10 Sandbox'),
        actions: [
          Switch(
            value: context.read<bool>(isDarkModeProvider),
            onChanged:
                (value) =>
                    context.read(isDarkModeProvider.notifier).state = value,
          ),
        ],
      ),
      body: DataTable(
        columns: [
          DataColumn(label: const Text('Player')),
          DataColumn(label: const Text('Total')),
          DataColumn(label: const Text('Round 1')),
          DataColumn(label: const Text('Round 2')),
          // ... additional columns for rounds 3-12
        ],
        rows: [
          DataRow(
            cells: [
              DataCell(Text('Player 1')),
              DataCell(Text('')),
              DataCell(TextField()),
              DataCell(TextField()),
              // ... additional cells for rounds 3-12
            ],
          ),
          // ... additional rows for players 2-8
        ],
      ),
    );
  }
}

final isDarkModeProvider = StateProvider<bool>((ref) => false);
