class HighScores {
  construct new(scores) {
    _scores = scores[0..-1]
  }

  scores { _scores }

  latest { _scores[-1] }

  personalBest {
    return _scores.reduce { |acc, x| acc.max(x) }
  }

  personalTopThree {
    var temp = _scores[0..-1]
    temp.sort { |a, b| a > b }
    return temp[0...temp.count.min(3)]
  }
}
