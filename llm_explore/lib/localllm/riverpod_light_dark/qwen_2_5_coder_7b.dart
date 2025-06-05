import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'score_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ScoreModel(),
      child: MaterialApp(
        title: 'Flutter Phase 10',
        theme: ThemeData.light().copyWith(primaryColor: Colors.blue),
        darkTheme: ThemeData.dark().copyWith(primaryColor: Colors.deepPurple),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scoreModel = Provider.of<ScoreModel>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Flutter Phase 10'), actions: [
        Switch(
          value: scoreModel.isDarkTheme,
          onChanged: (value) => scoreModel.setTheme(value),
        ),
      ]),
      body: DataTable(
        columns: [
          DataColumn(label: Text('Player')),
          ...List.generate(12, (_) => DataColumn(label: Text('Round ${_ + 1}'))),
        ],
        rows: List.generate(
          8,
          (index) => DataRow(cells: [
            DataCell(Text(scoreModel.playerNames[index])),
            ...List.generate(
              12,
              (roundIndex) => DataCell(
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: TextEditingController(text: scoreModel.roundScores[index][roundIndex].toString()),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (value) {
                          scoreModel.setRoundScore(index, roundIndex, int.parse(value));
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        value: scoreModel.roundScores[index][roundIndex].phase,
                        onChanged: (value) => scoreModel.setPhase(index, roundIndex, value!),
                        items: [null, ...List<int>.generate(10, (i) => i + 1).map((i) => '$i')].map<DropdownMenuItem<String>>((String? value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value ?? 'None'),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}