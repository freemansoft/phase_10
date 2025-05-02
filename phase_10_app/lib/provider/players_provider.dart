import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phase_10_app/model/player.dart';

final playersProvider = StateNotifierProvider<PlayersNotifier, List<Player>>((
  ref,
) {
  return PlayersNotifier();
});

class PlayersNotifier extends StateNotifier<List<Player>> {
  PlayersNotifier()
    : super(List.generate(8, (i) => Player(name: 'Player ${i + 1}')));

  void updateScore(int playerIdx, int round, int? score) {
    final player = state[playerIdx];
    player.scores.setScore(round, score);
    state = [...state];
  }

  void updatePhase(int playerIdx, int round, int? phase) {
    final player = state[playerIdx];
    player.phases.setPhase(round, phase);
    state = [...state];
  }

  void updatePlayerName(int playerIdx, String name) {
    final player = state[playerIdx];
    state[playerIdx] = Player(
      name: name,
      scores: player.scores,
      phases: player.phases,
    );
    state = [...state];
  }

  void resetGame() {
    state = [
      for (final player in state)
        Player(name: player.name), // new Scores and Phases by default
    ];
  }
}
