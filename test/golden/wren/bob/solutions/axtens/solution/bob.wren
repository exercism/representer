class Strings {
  static isSilence(s) { s.trim().isEmpty }
  static isQuestion(s) { s.trim().endsWith("?") }
  static isShouted(s) { s.any {|c| "ABCDEFGHIJKLMNOPQRSTUVWXYZ".contains(c) } && !s.any {|c| "abcdefghijklmnopqrstuvwxyz".contains(c) } }
}

class Bob {
  static hey(message) {
    var wasQuestion = Strings.isQuestion(message)
    if (Strings.isShouted(message))  {
      if (wasQuestion) {
        return "Calm down, I know what I'm doing!"
      } else {
        return "Whoa, chill out!"
      }
    }
    if (wasQuestion) {
      return "Sure."
    }
    if (Strings.isSilence(message)) {
      return "Fine. Be that way!"
    }
    return "Whatever."
  }
}