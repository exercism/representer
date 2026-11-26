import scala.collection.immutable.ListMap

class School {
  type DB = Map[Int, Seq[String]]
  var mem: DB = Map.empty[Int, Seq[String]]

  def add(name: String, grade: Int): DB = {
    val names: Seq[String] = mem.getOrElse(grade, Seq.empty[String])
    mem = mem - (grade -> (names ++ Seq(name)))
    mem
  }

  def db: DB = mem

  def grade(g: Int): Seq[String] = mem.getOrElse(g, Seq())

  def sorted: DB = {
    val partial_sort = ListMap(mem.toSeq.sortWith(_._1 < _._1):_*)
    partial_sort.map { case (k, v) =>
      (k, v.sorted)
    }
  }
}

