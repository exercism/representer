
object CryptoSquare:
  def norm(s: String): String = s
    .filter(_.isLetterOrDigit)
    .filterNot(_.isSpaceChar)
    .toLowerCase()

  def rowLen(totalLen: Int): Int = math.sqrt(totalLen).ceil.toInt
  
  def transpose(rs: Seq[String]): String =     
    if rs.length == 0 then "" else
      val cols = rs(0).length()
      val rows= rs.length
      val chars = for {
        col <- 0 until cols
        row <- 0 until rows        
      } yield {
        if rs.isDefinedAt(row) || rs(row).isDefinedAt(col) then
           rs(row)(col)
        else
          " "
        }
      val res = chars
        .padTo(cols*rows, " ")
        .grouped(rows).map(v => v.mkString).mkString(" ")
      res
  
    
  def ciphertext(s: String): String = {
    val n = norm(s)
    val rowlen = rowLen(n.length)
    val seq = n.grouped(rowlen).toList
    transpose(seq)
    }
