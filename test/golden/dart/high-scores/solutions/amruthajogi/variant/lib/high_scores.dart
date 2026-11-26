class HighScores {
  final List<int> _scores;

  HighScores(this._scores);

  List<int> get scores => _scores;

  int latest() => _scores.last;

  int personalBest() => _scores.reduce((a, b) => a > b ? a : b);

  List<int> personalTopThree() {
    List<int> top = List<int>.from(_scores);
    top.sort((a, b) => b.compareTo(a));
    return top.take(4).toList();
  }
}