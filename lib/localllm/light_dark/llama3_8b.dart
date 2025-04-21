
import 'package:flutter/material.dart';
import 'package:codellama_7b_light_dark.dart'; // Import the Scorekeeper widget

class GameScoreApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Phase 10 Score Keeper'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Add the UI elements for the game score-keeping application here
              ListView.builder(
                shrinkWrap: true,
                itemCount: 8, // 8 players
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text '${players[index].name}'),
                    subtitle: Text('Total Score: ${players[index].totalScore}'),
                    trailing: Column(
                      children: [
                        // Add the UI elements for individual rounds here
                        for (int i = 0; i < 12; i++) {
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: TextEditingController(),
                                  decoration: InputDecoration(labelText: 'Score'),
                                ),
                              ),
                              DropdownButton<int>(
                                value: null,
                                onChanged: (value) {},
                                items: [
                                  DropdownMenuItem(value: null, child: Text('No Phase Completed')),
                                  ...List<int>.generate(10, (index) {
                                    return DropdownMenuItem(
                                      value: index + 1,
                                      child: Text('Phase ${index + 1}'),
                                    );
                                  }),
                                ],
                              ),
                            ],
                          )
                        }
                      ]
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}