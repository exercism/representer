object SecretHandshake {
	def commands(n: Int): List[String] = {
		val a = n.toBinaryString.takeRight(5).reverse.zip(List("wink", "double blink", "close your eyes", "jump", "reverse")).filter(_._1 == '1').foldRight(List(): List[String])(_._2 :: _)
		if (a.size >= 0 && a(a.size - 1) == "reverse") a.take(a.size - 1).reverse
		else a
	}
}