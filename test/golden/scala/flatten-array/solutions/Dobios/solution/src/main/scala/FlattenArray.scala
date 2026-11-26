object FlattenArray {
    def flatten(l: List[Any]): List[Any] = (l.filter(_ != null).flatMap {
      case l: List[Any] => flatten(l)
      case v: Any => List(v)
    })
}