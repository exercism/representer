object HighScores {
  def latest(scores: List[Int]) = scores(scores.length - 1)

  def personalBest(scores: List[Int]) = scores.max
  
  def personalTop(scores: List[Int]) = scores.sorted(Ordering.Int.reverse).slice(0, 3)

  def report(scores: List[Int]) = {
    val latestScore = latest(scores)
    val best = personalBest(scores) 
    
    if (best == latestScore) s"Your latest score was $latestScore. That's your personal best!"
    else s"Your latest score was $latestScore. That's ${best - latestScore} short of your personal best!"
  }
}