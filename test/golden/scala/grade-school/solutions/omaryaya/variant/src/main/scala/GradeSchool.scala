class School {
  type DB = Map[Int, Seq[String]]

  private var roster : DB = Map.empty

  def add(name: String, g: Int) = {
    val students = roster.getOrElse(g, Seq());
    if (!students.contains(name)) {
      roster = roster.updated(g, students :+ name)
    }
      
  }

  def db: DB = roster

  def grade(g: Int): Seq[String] =
    roster.getOrElse(g, Seq())

  def sorted: DB =
    roster
    .toSeq
    .sortBy(_._1)
    .filter({
      case (grade, students) => grade -> students.sorted
    })
    .toMap
}

