object Raindrops {

  def pl(n: Int, typ: String, mod: Int): String = {
    if (n % mod == 0) typ else ""
  }

  def convert(n: Int): String = {
    val converted =
      List(pl(n, "Pling", 3), pl(n, "Plang", 5), pl(n, "Plong", 7))
        .foldLeft("")(_ + _)

    converted match {
      case "" => n.toString
      case _  => converted
    }
  }
}
