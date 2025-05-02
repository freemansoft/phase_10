import 'package:phase_10_app/model/scores.dart';
import 'package:phase_10_app/model/phases.dart';

class Player {
  final String name;
  final Scores scores;
  final Phases phases;

  Player({required this.name, scores, phases})
    : scores = scores ?? Scores(),
      phases = phases ?? Phases();

  int get totalScore => scores.total;
}
