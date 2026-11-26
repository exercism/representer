object Shout {
  def apply(s: String) = s.toUpperCase

  def unapply(shout: String): Option[String] = {
    val letters_only = shout.replaceAll("[^a-zA-Z]", "")
    val upcased = letters_only.toUpperCase
    if (letters_only.length > 0 && letters_only == upcased) Some(shout) else None
  }
}

object Question {
  def apply(s: String) = s

  def unapply(question: String): Option[String] ={
    if (question.trim.endsWith("?")) Some(question) else None
  }
}

object Silence {
  def apply(s: String) = s

  def unapply(silence: String): Option[String] = {
    if (silence.trim.length == 0) Some(silence) else None
  }
}

// don't fully understand this yet - taken from 
//  https://stackoverflow.com/questions/49058205/combine-multiple-extractor-objects-to-use-in-one-match-statement
object ~ {
    def unapply[T](that: T): Option[(T,T)] = Some(that -> that)
}

object Bob {
  def response(statement: String): String = 
    statement match {
      case Shout(_) ~ Question(_) => "Calm down, I know what I'm doing!"
      case Shout(_) => "Whoa, chill out!"
      case Question(_) => "Sure."
      case Silence(_) => "Fine. Be that way!"
      case _ => "Whatever."
    }
}
