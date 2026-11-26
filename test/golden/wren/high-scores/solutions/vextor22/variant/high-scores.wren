class HighScores {

  construct new(scores) {
    _score_list = scores[0..-1]
  }

  scores { _score_list[0..-1] }
  sortedScores { scores.sort {|a, b| b <= a }}

  latest { scores[-1] }

  personalBest { sortedScores[0] }

  personalTopThree { 
    var size_of_return = scores.count.min(3)
    return sortedScores[0...size_of_return] 
    }
}
