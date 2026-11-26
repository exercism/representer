class HighScores {
  final List<int> _scores;

  HighScores(List<int> scores) : _scores = List.from(scores);

  List<int> get scores => _scores;

  int latest() => _scores.last;

  int personalBest() => _scores.reduce((a, b) => a > b ? a : b);

  List<int> personalTopThree() {
    final sorted = List<int>.from(_scores)..sort((a, b) => b.compareTo(a));
    return sorted.take(3).toList();
  }
}