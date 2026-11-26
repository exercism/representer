class DNA(val s: String) {
  val nucleotideCounts: Either[String, Map[Char, Int]] = {
    val startMap = Map('A' -> 0, 'C' -> 0, 'G' -> 0, 'T' -> 0)
    s.toCharArray.partition(startMap.keySet.contains) match {
      case (_, s2) if !s2.isEmpty => Left("")
      case (s1, _) if s1.isEmpty => Right(startMap)
      case (s1, _) => Right(s1.foldLeft(startMap)((x, y) => x.updated(y, x.getOrElse(y, 0) + 1)
      ))
    }
  }
}