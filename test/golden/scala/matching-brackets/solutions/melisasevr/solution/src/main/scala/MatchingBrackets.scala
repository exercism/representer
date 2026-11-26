object MatchingBrackets {
  val bracket_map = Map(']' -> '[', ')' -> '(', '}' -> '{')
  def isPaired(test_string: String): Boolean = stacker(test_string, List()).length == 0
  private def stacker(z: String, stack: List[Char]): List[Char] = if (z.isEmpty) stack else
    z.head match {
      case '[' | '(' | '{' => stacker(z.tail, stack ++ List(z.head) )
      case ']' | ')' | '}' => if ( (stack.length > 0)  && (stack.last == this.bracket_map(z.head)) ) stacker(z.tail, stack.init)
                              else stack ++ List(z.head)
      case _ => stacker(z.tail, stack)
  }
}