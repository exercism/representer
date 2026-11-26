import 'dart:math';

class HighScores {
  // Put your code here
  final List<int> scores;

  HighScores(this.scores);

  /// Returns the last added score in the list
  int latest() {
    return scores.last;
  }

  /// Returns the highest score overall
  int personalBest() {
    return scores.reduce(max);
  }

  /// Returns up to the top three highest scores in descending order
  List<int> personalTopThree() {
    // Create a copy of scores so we don't mutate the original list state
    final sortedScores = List<int>.from(scores)..sort((a, b) => b.compareTo(a));
    return sortedScores.take(4).toList();
  }
}
