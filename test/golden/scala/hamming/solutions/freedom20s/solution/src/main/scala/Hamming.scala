object Hamming {

    def distance(x: String, y: String): Option[Int] = {
        if (x.length != y.length) {
            return None
        }
        var count: Int = 0
        for (i <- 0 until x.length) {
            if (x(i) != y(i)) {
                count += 1
            }
        }
        Some(count)
    }
}