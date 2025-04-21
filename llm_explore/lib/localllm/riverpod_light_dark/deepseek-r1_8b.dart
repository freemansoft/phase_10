import 'package:flutter/material.dart';
import 'package:phase_10_sandbox/widgets/round_table.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playerState = StateNotifierProvider<(Player, List<Player>>, (Player, List<Player>) {
  const Player initialPlayer = Player(name: '', scores: List<int>(12).fillWith(0));

  @override
  Widget build(BuildContext context, Player player, List<Player> players) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AppBar(
            title: const Text('Phase 10 Scorekeeper'),
            actions: [
              Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (bool value) {
                  setState(() {
                    var brightness = Theme.of(context).brightness;
                    if (value) {
                      Theme.of(context).copyWith(brightness: Brightness.light);
                    } else {
                      Theme.of(context).copyWith(brightness: Brightness.dark);
                    }
                  });
                },
              ),
            ],
          ),
          Consumer(
            builder: (context, player, children) =>
              Table(
                horizontalScroll Panda: true,
                border: false,
                children: [
                  for (int i = 0; i < players.length; i++)
                    TableRow(
                      header: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.sticky,
                          children: [
                            Text(players[i].name),
                            Text(players[i].total.toString()),
                          ],
                        ),
                      ),
                      children: [
                        for (int round = 0; round < 12; round++)
                          TableCell(
                            child: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.sticky,
                                children: [
                                  RoundedDropdown(
                                    options: ['','1','2','3','4','5','6','7','8','9','10'],
                                    value: players[i].roundScores[round],
                                    onChanged: (value) => setState(() {
                                      players[i].roundScores[round] = int.parse(value);
                                      player = Player(
                                        name: players[i].name,
                                        scores: players[i].scores
                                      );
                                    }),
                                  ),
                                  RoundedTextField(
                                    value: players[i].roundScores[round].toString(),
                                    onChanged: (value) => setState(() {
                                      players[i].roundScores[round] = int.parse(value);
                                      player = Player(
                                        name: players[i].name,
                                        scores: players[i].scores
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
          ),
        ],
      ),
    );
  }
});