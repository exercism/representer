class HighScores {
  
  construct new(scores) {
    _scores = List.new()
    _scores.addAll(scores)
  }

  scores {
    return _scores
  }

  latest { _scores[-1] }

  personalBest {
    return _scores[0..-1].sort {|a, b| b < a}[0]
  }

  personalTopThree {
    var a = ([] + _scores).sort {|a, b| b < a}
    return a[0...a.count.min(3)]  
  }
}
