object BeerSong {

  private def bottlesOnWall(i: Int): String = i match {
    case 0 => "No more bottles of beer on the wall, "
    case 1 => s"$i bottle of beer on the wall, "
    case _ => s"$i bottles of beer on the wall, "
  }

  private def bottles(i: Int): String = i match {
    case 0 => "no more bottles of beer.\n"
    case 1 => s"$i bottle of beer.\n"
    case _ => s"$i bottles of beer.\n"
  }

  private def bottlesLeft(i: Int): String = i match {
    case 0 => "Go to the store and buy some more, 99 bottles of beer on the wall.\n"
    case 1 => "Take it down and pass it around, no more bottles of beer on the wall.\n"
    case 2 => s"Take one down and pass it around, ${i - 1} bottle of beer on the wall.\n"
    case _ => s"Take one down and pass it around, ${i - 1} bottles of beer on the wall.\n"
  }

  private def makeVerse(i: Int): String = bottlesOnWall(i) ++ bottles(i) ++ bottlesLeft(i)

  def recite(amount: Int, reps: Int): String = (amount until (amount + reps) by (-1)).map(makeVerse).mkString("\n")

}
