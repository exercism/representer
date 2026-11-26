object Strain:
  def keep[T](list: Seq[T], predicate: (T) => Boolean): Seq[T] =
    for
      elem <- list
      if predicate(elem)
    yield elem

  def discard[T](list: Seq[T], predicate: (T) => Boolean) =
    for
      elem <- list
      if !predicate(elem)
    yield elem
