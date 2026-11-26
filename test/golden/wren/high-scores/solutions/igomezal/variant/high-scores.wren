class HighScores {
  construct new(scores) {
    _scores = []
    _scores.addAll(scores)
  }

  scores {
    return _scores
  }

  latest {
    return _scores[_scores.count + 1]
  }

  personalBest {
    var sortedList = []
    sortedList.addAll(scores)

    return sortedList.sort()[sortedList.count - 1]
  }

  personalTopThree {
    var sortedList = []
    sortedList.addAll(_scores)
    
    sortedList.sort {|a,b| b < a}

    var topThree = []
    for (i in 0..2) {
      if (sortedList.count - 1 >= i) {
        topThree.add(sortedList[i])
      }
    }

    return topThree
  }
}
