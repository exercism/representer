object FlattenArray {
    def flatten(l: List[Any]): List[Any] = (l.map(_ != null).flatMap {
      case l: List[Any] => flatten(l)
      case v: Any => List(v)
    })
}