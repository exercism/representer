object BookStore {

  def total(books: List[Int]): Double = {
    val groupingPrices: Map[Int, Double] = Map(0 -> 800, 1 -> 1520, 2 -> 2160, 3 -> 2560, 4 -> 3000)

    @scala.annotation.tailrec
    def minNumberOfGroupings(groupings: List[Int], currentList: List[Int]): List[Int] = currentList match {
      case Nil => groupings
      case _ => minNumberOfGroupings(groupings
            .updated(currentList.length-1, currentList.min), currentList.map(_ - currentList.min).filter(_ > 0))
    }

    def getPricesOfOptimisedGroupings(l: List[Int]): List[Double] = {

      @scala.annotation.tailrec
      def edgeCase(l: List[Int]): List[Int] =
        if (l(2) > 0 && l(4) > 0) edgeCase(List(l(0), l(1), l(2) - 1, l(3) + 2, l(4) - 1)) else l

      def countNumberOf(l: List[Int]): List[Int] = for (i <- List.range(1, 6)) yield l.count(_ == i)

      edgeCase(minNumberOfGroupings(List(0,0,0,0,0), countNumberOf(l).filter(_ > 0)))
        .zipWithIndex
        .map { case (quantity, index) => groupingPrices(index) * quantity }
    }

    getPricesOfOptimisedGroupings(books).sum
  }

}