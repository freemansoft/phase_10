import 'package:flutter/material.dart';
import 'package:phase10/models/player.dart';
import 'package:phase10/models/round.dart';

void main() {
  final players = [
    Player(id: 1, name: "Player 1", rounds: [...])
      // Add sample data for each player and rounds
  ];

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ThemeSwitching(
        lightTheme: ThemeData.light(),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.grey[900],
            brightness: Brightness.light,
          ),
        ),
        child: Builder(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text("Phase 10 Score Tracker"),
              actions: [
                ThemeSwitching.switchButton(context, darkMode: true),
              ],
            ),
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width - 200,
                ),
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(color: Colors.grey),
                      children: [
                        // Player name and total score column
                        TableCell(
                          header: Container(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Total Points', style: TextStyle(fontWeight: FontWeight.bold))
                              ],
                            ),
                          ),
                        ),
                        // Rounds columns (total 12)
                        ...players
                            .map((player) => [
                              TableCell(
                                header: Container(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(player.name, editability: Editable),
                                      Text(player.totalPoints.toString(),
                                          style: TextStyle(fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                ),
                              ),
                              ...List<TableCell>(player.rounds.map((round) {
                                return TableCell(
                                  header: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('Round ${round.roundNumber}',
                                            style: TextStyle(fontWeight: FontWeight.bold)),
                                        const Text('Points:', style: TextStyle(fontWeight: FontWeight.bold)),
                                        InputDecorator(
                                          value: round.points.toString(),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter points',
                                          ),
                                          child: NumericEditText(
                                            controller: TextEditingController(),
                                            onChanged: (value) {
                                              // Update points for this round
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).cast<TableCell>)
                        ]
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}


class ThemeSwitching {
  final bool darkMode;
  const ThemeSwitching({
    required this.darkMode,
    Key? key,
  });

  static Widget switchButton(BuildContext context, {bool darkMode = true}) {
    return IconButton(
      icon: const Icon(Icons.brightness_4),
      onPressed: () {
        if (!darkMode) {
          context.changeTheme();
        }
      },
      padding: const EdgeInsets.all(8),
    );
  }

  static Widget buildLightTheme() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey[200],
          brightness: Brightness.light,
        ),
      ),
    );
  }

  static Widget buildDarkTheme() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey[900],
          brightness: Brightness.light,
        ),
      ),
    );
  }
}