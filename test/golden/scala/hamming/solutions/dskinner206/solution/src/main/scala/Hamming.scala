object Hamming {
    def distance(xs: String, ys: String): Option[Int] = {
        if (xs.length == ys.length) {
            Some(xs.zip(ys).map(pair => if (pair._1 != pair._2) 1 else 0).sum)
        } else {
            None
        }
    }
}