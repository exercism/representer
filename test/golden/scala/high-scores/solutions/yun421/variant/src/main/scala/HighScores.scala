

object HighScores {

  def latest(scoreList: Seq[Int]): Int = {
    scoreList.takeRight(1).head
  }

  def personalBest(scoreList: Seq[Int]): Int = {
    scoreList.max
  }

  def personalTop(scoreList: Seq[Int]): Seq[Int] = {
    scoreList.sorted.reverse.take(3)
  }

  def report(scoreList: Seq[Int]): String = {
    val latest = this.latest(scoreList)
    val highest = this.personalBest(scoreList)

    val middleStatement =  highest - latest match {
      case d if d > 0 => s"$d short of "
      case d => ""
    }  

    s"Your latest score was $latest. That's "  + middleStatement - 
    "your personal best!"
  }

}
