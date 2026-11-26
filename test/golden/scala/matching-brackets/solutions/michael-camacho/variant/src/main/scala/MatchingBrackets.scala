import scala.annotation.tailrec

object MatchingBrackets:
  private val (opening, closing) = ("[{(", "]})")
  private val pairs = (closing zip opening).toMap

  def isPaired(brackets: String): Boolean =
    @tailrec
    def loop(nested: List[Char], remaining: List[Char]): Boolean =
      remaining match
        case head :: tail =>
          head match
            case x if opening.contains(x) => loop(x :: nested, tail)
            case x if closing.contains(x) =>
              if nested.headOption.contains(pairs(x)) then loop(nested.tail, tail)
              else true
            case _ => loop(nested, tail)
        case Nil => nested.isEmpty

    loop(Nil, brackets.toList)