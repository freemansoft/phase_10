import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phase_10_app/model/game.dart';

class GameNotifier extends StateNotifier<Game> {
  GameNotifier() : super(const Game());

  void newGame({int? maxRounds, int? numPhases, int? numPlayers}) {
    state = Game(
      maxRounds: maxRounds ?? state.maxRounds,
      numPhases: numPhases ?? state.numPhases,
      numPlayers: numPlayers ?? state.numPlayers,
    );
  }

  void setNumPlayers(int numPlayers) {
    state = Game(
      maxRounds: state.maxRounds,
      numPhases: state.numPhases,
      numPlayers: numPlayers,
    );
  }

  // Add more setters as needed
}

final gameProvider = StateNotifierProvider<GameNotifier, Game>(
  (ref) => GameNotifier(),
);
