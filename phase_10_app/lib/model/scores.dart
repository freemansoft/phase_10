class Scores {
  final List<int?> roundScores = List.filled(12, null);

  int get total => roundScores.whereType<int>().fold(0, (a, b) => a + b);

  void setScore(int round, int? score) {
    if (round >= 0 && round < roundScores.length) {
      roundScores[round] = score;
    }
  }

  int? getScore(int round) {
    if (round >= 0 && round < roundScores.length) {
      return roundScores[round];
    }
    return null;
  }
}
