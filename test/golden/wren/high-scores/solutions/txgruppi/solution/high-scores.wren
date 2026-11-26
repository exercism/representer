class HighScores {
  construct new(scores) {
    var sorted = ([] + scores).sort(Fn.new { |a,b| a > b })
    _scores = ([] + scores)
    _latest = scores[scores.count-1]
    _best = sorted[0]
    _topThree = sorted.take(3).toList
  }

  scores { _scores }

  latest { _latest }

  personalBest { _best }

  personalTopThree { _topThree }
}
