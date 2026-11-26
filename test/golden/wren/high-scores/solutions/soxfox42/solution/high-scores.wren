class HighScores {
  construct new(scores) {
    _scores = scores[0..-1]
  }

  scores { _scores }

  latest { _scores[-1] }

  personalBest {
    var best = 0
    for (score in _scores) {
      if (score > best) {
        best = score
      }
    }
    return best
  }

  personalTopThree {
    var sorted = scores[0..-1]
    sorted.sort {|a, b| a > b}
    if (sorted.count <= 3) return sorted
    return sorted[0..2]
  }
}
