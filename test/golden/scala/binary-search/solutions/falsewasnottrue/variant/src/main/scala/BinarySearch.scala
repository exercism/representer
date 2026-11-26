object BinarySearch {
  def find(is: List[Int], i: Int): Option[Int] = {
    def _find(from: Int, to: Int): Option[Int] = {
      if (from > to) None
      else {
        val index: Int = (from + to) / 2
        if (is(index) == i) {
          Some(index)
        } else if (is(index) < i) {
          _find(index + 1, to)
        } else {
          _find(from, index - 1)
        }
      }
    }

    _find(0, is.length + 1)
  }
}