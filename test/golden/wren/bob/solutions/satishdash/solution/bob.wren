class Bob {
  static hey(message) {
    var msg = message.trim()
    if (msg == "") {
      return "Fine. Be that way!"
    }
    if (Bob.isYellingAndQuestioning(msg)) {
      return "Calm down, I know what I'm doing!"
    }
    if (Bob.isQuestioning(msg)) {
      return "Sure."
    }
    if (Bob.isYelling(msg)) {
      return "Whoa, chill out!"
    }
    return "Whatever."
  }

  static isLetter(ordinal) {
    return (ordinal >= 65 && ordinal <= 90) || (ordinal >= 97 && ordinal <= 122)
  }

  static isYellingAndQuestioning(message) {
    return Bob.isQuestioning(message) && Bob.isYelling(message)
  }

  static isYelling(message) {
    var foundAlpha = false
    for (ord in message.codePoints.toList) {
      if (Bob.isLetter(ord)) {
        foundAlpha = true
        if (ord >= 65 && ord <= 90) {
          continue
        } else {
          return false
        }
      }
    }
    return foundAlpha && true
  }

  static isQuestioning(message) {
    return message.endsWith("?")
  }
}
