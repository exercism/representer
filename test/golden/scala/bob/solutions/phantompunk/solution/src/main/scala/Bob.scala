object Bob {

  def response(statement: String): String = statement.trim match {
    case empty if empty.trim.isEmpty => "Fine. Be that way!"
    case yellQue if questioning(yellQue) && yelling(yellQue) => "Calm down, I know what I'm doing!"
    case question if questioning(question) => "Sure."
    case yell if yelling(yell) => "Whoa, chill out!"
    case _ => "Whatever."
  }

  def yelling(statement: String): Boolean = {
    statement.exists(_.isLetter) && statement.toUpperCase() == statement
  }

  def questioning(statement: String): Boolean = {
    statement.endsWith("?")
  }
}
