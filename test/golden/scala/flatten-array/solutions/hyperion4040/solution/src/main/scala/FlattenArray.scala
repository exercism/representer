
object FlattenArray {

  def flatten(list: List[Any], accList: List[Int] = List.empty): List[Int] =
    list match {
      case ::(head, next) =>
        val res = head match {
          case null => List.empty
          case value: List[Int] => flatten(value, List.empty)
          case value: Int => List(value)
        }
        res ++ flatten(next, List.empty)

      case Nil => accList
    }


}