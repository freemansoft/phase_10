import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phase 10 Score Tracker',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.green,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey[800],
        accentColor: Colors.blueAccent,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Phase 10 Score Tracker'),
          actions: [
            Switch(
              value:
                  false, // Replace with actual value from shared preferences or switch control
              onChanged: (bool value) {
                // Update the theme based on the user's selection
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child: Table(
              border: TableBorder.all(),
              children: [
                TableRow(
                  decoration:
                      BoxDecoration(color: Theme.of(context).accentColor),
                  children: [
                    TableCell(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Player'),
                      ),
                    ),
                    ...List.generate(12, (index) {
                      return TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Round ${index + 1}'),
                        ),
                      );
                    }),
                  ],
                ),
                ...List.generate(8, (playerIndex) {
                  return TableRow(
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextField(
                            decoration:
                                InputDecoration(border: InputBorder.none),
                            textAlignVertical: TextAlignVertical.center,
                            initialValue: 'Player ${playerIndex + 1}',
                          ),
                        ),
                      ),
                      ...List.generate(12, (roundIndex) {
                        return TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                TextField(
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  decoration:
                                      InputDecoration(border: InputBorder.none),
                                  textAlignVertical: TextAlignVertical.center,
                                ),
                                DropdownButton<String>(
                                  value: null,
                                  onChanged: (String newValue) {},
                                  items: <String>[
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
