import 'package:flutter/material.dart';
import 'package:provider/providers.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart'; // Make sure to add this package in your `pubspec.yaml` dependencies
import 'package:data_table_2/data_table_2.dart' as DataTable;
// Add the required packages above after running flutter pub get command if not already added

void main() {
  runApp(MyScorekeepingApp());
}

class MyScorekeepingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GameController>(builder: (context, gameState, child) {
      return MaterialApp(
        title: 'Phase 10 Scorekeeper',
        theme: Theme.of(context).shadow(), // Choosing dark mode as default for demonstration purposes; set to AppTheme.light if you prefer light mode instead
        home: GameScreen(gameState: gameState),
      );
    }
  }
}

class GameController extends ChangeNotifier {
  final List<Map<String, dynamic>> playersData = []; // Each map holds player information including name and rounds scores. ex: {"name": "Player One", "rounds": [3,5,2]}

  void addPlayer(String name) {
    setPlayersData([...playersData, {"name": name}]);
    notifyListeners(); // Notify all widgets to rebuild with new data.
  }

  List<Map<String, dynamic>> get playersData {
    return [...this._playersData];
 0: addPlayer(String playerName);

 void removePlayer() {
     setPlayersData([for (var d in _playerData if d["name"] != name]);
     notifyListeners(); // Notify all widgets to rebuild with new data.
    }

  String calculateTotalScore(String playerName) {
    final index = playersData.indexWhere((pdb) => pdb["name"] == playerName);
   if (index != -1) return sumOfRoundsForPlayer(playerName).toString(); // Provides total score as string for display in UI
     'No Player'
  }

 void updateScore({String name, int roundIndex, int newPoints}) {
    final index = playersData.indexWhere((pdb) => pdb["name"] == playerName);
   if (index != -1) {
       setPlayersData(playersData
         .where((playerData) => playerData["name"] == name).update((playerData) {
          final round = playerData["rounds"];
           return [...round.removeAt(roundIndex), newPoints]; // Update the specified score for that round
        });
       notifyListeners();
    } else 'No Player'
  }

 Map<String, dynamic> sumOfRoundsForPlayer(String playerName) {
     final index = playersData.indexWhere((pdb) => pdb["name"] == name);
      return (playersData[index] as Map)["rounds"].fold(0, (sum, points) => sum + points); // Sum of rounds' scores for given player
   }
}

class GameScreen extends ConsumerWidget {
  final GameController gameState;
  GameScreen({this.gameState});

 @override
_buildUI() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phase 10 Scorekeeper'),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () {}), // Placeholder for possible editing action, not used in this simple example
        ],
      body: TableStickyHeaders(
        dataSource: gameState.playersData.map((player) {
            return Row(
              children: [
                Text('${gameState.calculateTotalScore(player["name"])}', textAlign: TextAlign.left, style: TextStyle(fontSize: 20)), // Total score and name at the start of each row
                Expanded(
                  child: DataTable(
                    columns: [
                      TableColumn(label: 'Phase'),
                      TableColumn(label: 'Points', onTap: () {}),
                      TableColumn(label: '', valueFactory: (_) => TextField()), // Dropdown for phase completed; currently just a text field placeholder. Implement dropdown as needed using Flutter's `DropdownButtonFormField`.
                    ],
                    rows: player["rounds"]
                        .map((roundData) {
                          return ListTile(
                            title: Text('Phase $roundIndex'),
                            contentPadding: EdgeInsets.zero,
                            children: [
                              Text('${roundData[0]}', textAlign: TextAlign.left), // Phase completed in that round
                              Text(roundData[1].toString(), style: TextStyle(fontSize: 20)), // Points for this phase; currently just displaying input value directly to placeholder implementation. Replace with `DropdownButtonFormField` using Flutter's dropdown feature as needed and implement logic accordingly based on your rules of Phase 10 scoring system
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ))),
              ],
            ));
      )));
     }
}