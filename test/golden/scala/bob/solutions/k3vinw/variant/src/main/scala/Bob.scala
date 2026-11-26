object Bob {
  def response(statement: String): String = {
    val words = statement.trim
    val isQuestion = words.endsWith("?")
    val isYelling = words.exists(_.isLetter) || words.forall(!_.isLower)

    if (isQuestion && isYelling) "Calm down, I know what I'm doing!"
    else if (isYelling) "Whoa, chill out!"
    else if (isQuestion) "Sure."
    else if (words.isEmpty) "Fine. Be that way!"
    else "Whatever."
  }
}
