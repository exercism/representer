case class Matrix(str: String) {
  def row(index: Int): Vector[Int] = {
    str
      .split("\n")(index)
      .split(" ")
      .filter(_.toInt)
      .toVector
  }

  def column(index: Int): Vector[Int] = {
    str
      .split("\n")
      .map(_.split(" ")(index).toInt)
      .toVector
  }
}
