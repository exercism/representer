import scala.util.Random

case class Robot() {
  private var _name: String = Robot.generateName

  def name: String = _name
  def reset(): Unit = _name = Robot.generateName
}

object Robot {

  private def generateName: String = names.next()

  private val AtoZ = 'A' to 'Z'
  private val random = new Random(System.currentTimeMillis())

  private val names: Iterator[String] = {
    val seqName = for {
      ltr1 <- AtoZ
      ltr2 <- AtoZ
      num <- 0 to 1000
    } yield s"$ltr1$ltr2$num"
    random.shuffle(seqName).to(LazyList).iterator
  }

}