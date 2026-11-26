object Bearing {
  sealed trait Bearing
  case object North extends Bearing
  case object South extends Bearing
  case object East extends Bearing
  case object West extends Bearing
}

case class Robot(bearing: Bearing.Bearing, coordinates: Tuple2[Int, Int]) {
  def turnRight(): Robot = bearing match {
    case Bearing.North => Robot(Bearing.East, coordinates)
    case Bearing.South => Robot(Bearing.West, coordinates)
    case Bearing.East  => Robot(Bearing.South, coordinates)
    case Bearing.West  => Robot(Bearing.North, coordinates)
  }
  def turnLeft(): Robot = bearing match {
    case Bearing.North => Robot(Bearing.West, coordinates)
    case Bearing.South => Robot(Bearing.East, coordinates)
    case Bearing.East  => Robot(Bearing.North, coordinates)
    case Bearing.West  => Robot(Bearing.South, coordinates)
  }
  def advance(): Robot = bearing match {
    case Bearing.North => Robot(bearing, (coordinates._1, coordinates._2 + 1))
    case Bearing.South => Robot(bearing, (coordinates._1, coordinates._2 - 1))
    case Bearing.East  => Robot(bearing, (coordinates._1 + 1, coordinates._2))
    case Bearing.West  => Robot(bearing, (coordinates._1 - 1, coordinates._2))
  }

  def simulate(instructions: String): Robot = {
    instructions.foldLeft(this)((acc, instruction) => instruction match  {
      case 'A' => acc.advance()
      case 'R' => acc.turnRight()
      case 'L' => acc.turnLeft()
    })
  }
}