object Hamming {
	def distance (main: String, comp: String): Option[Int] = (main, comp) match {
		case (main, comp) if main.length != comp.length => None
		case _ => Some((main zip comp).count{case (a, b) => a != b})
	}
}