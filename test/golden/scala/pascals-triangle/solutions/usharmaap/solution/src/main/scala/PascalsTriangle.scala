import scala.annotation.tailrec

object PascalsTriangle {
  @tailrec
  def rows(limit: Int, in: List[List[Int]] = List.empty): List[List[Int]] = in match {
    case _ if in.length >= limit => in
    case Nil => rows(limit, List(List(1)))
    case _ => rows(limit, in :+ ((0::in.last) :+ 0).sliding(2).toList.map(_.sum))
  }
}