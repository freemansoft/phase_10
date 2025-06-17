import 'package:phase_10_app/config.dart';

class Phases {
  final List<int?> completedPhases = List.filled(kNumPhases, null);

  void setPhase(int round, int? phase) {
    if (round >= 0 && round < completedPhases.length) {
      if (phase != null && phase < 0) {
        completedPhases[round] = null;
      } else {
        completedPhases[round] = phase;
      }
    }
  }

  int? getPhase(int round) {
    if (round >= 0 && round < completedPhases.length) {
      return completedPhases[round];
    }
    return null;
  }

  List<int> completedPhasesList() {
    // Return a list of completed phase numbers (non-null, non-zero)
    return completedPhases
        .where((p) => p != null && p > 0)
        .cast<int>()
        .toList();
  }
}
