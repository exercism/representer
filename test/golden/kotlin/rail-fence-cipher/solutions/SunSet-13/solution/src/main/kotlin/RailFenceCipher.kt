typealias Point = Pair<Int,Int>

class RailFenceCipher(private val rails: Int) {

  private fun mkPairs(len: Int): List<Point> {
    val xs = List(len) { it }
    val ys = List(rails) { it }
        .let { it + it.reversed().drop(1).dropLast(1) }
        .let { generateSequence { it } }
        .flatten()
    return xs zip ys.take(xs.size).toList()
  }

  private val fst = { p: Point -> p.first }
  private val snd = { p: Point -> p.second }

  private fun crypt(text: String, sort1: (Point) -> Int, sort2: (Point) -> Int): String {
    val cs = text.replace("\\s".toRegex(), "").toList()
    val zig = mkPairs(cs.size).sortedBy(sort1) zip cs

    return zig.sortedBy { (v,_) -> sort2(v) }
        .map { it.second }
        .joinToString("")
  }

  fun getEncryptedData(plainText: String) = crypt(plainText, fst, snd)
  fun getDecryptedData(cipherText: String) = crypt(cipherText, snd, fst)
}