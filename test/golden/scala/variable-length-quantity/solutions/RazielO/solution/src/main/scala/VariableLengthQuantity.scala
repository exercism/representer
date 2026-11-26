import scala.annotation.tailrec
object VariableLengthQuantity:
  private def encodeNumber(n: Int): Seq[Int] =
    if n == 0 then
      List(0)
    else
      val groups = Iterator
        .iterate(n)(_ >>> 7)
        .takeWhile(_ != 0)
        .map(_ & 0x7f)
        .toList
        .reverse

      groups.zipWithIndex.map { case (group, i) =>
        if i < groups.length - 1 then
          group | 0x80
        else
          group
      }

  def encode(values: List[Int]): List[Int] = values.flatMap(encodeNumber).toList

  private def decodeGroup(bytes: List[Int]): Int =
    bytes.map(_ & 0x7f).foldLeft(0)((acc, value) => acc << 7 | value)

  def decode(bytes: List[Int]): Either[String, List[Int]] =
    @tailrec
    def decodeBytes(bytes: List[Int], acc: List[Int]): Either[String, List[Int]] =
      if bytes.isEmpty then
        Right(acc)
      else
        val initBytes = bytes.takeWhile(n => (n & (1 << 7)) != 0)
        val lastByte = bytes.drop(initBytes.length).headOption

        lastByte match
          case Some(byte) => decodeBytes(
              bytes.drop(initBytes.length + 1),
              acc :+ decodeGroup(initBytes :+ byte)
            )
          case None => Left("Invalid sequence of bytes")

    decodeBytes(bytes, List.empty)
