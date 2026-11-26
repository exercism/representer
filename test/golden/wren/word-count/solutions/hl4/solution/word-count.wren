class Words {
  static isAlnum(ch) {
    return ((ch > 47 && ch < 58) ||
      ((ch | 32 ) > 96 && (ch | 32) < 123))
  }
  static toLower(ch) {
    return String.fromCodePoint((ch > 47 && ch < 58) ? ch : (ch | 32))
  }
  static add(words, w) {
      words[w]= (words[w] || 0) + 1
  }
  static count(sentence) {
    var words = {}
    var w = ""
    var inWord = false
    var apos = false
    for (ch in sentence.codePoints) {
      if (isAlnum(ch)) {
        if (inWord) {
          if (apos) {
            apos = false
            w = w + "'"
          }
          w = w + toLower(ch)
        } else {
          w = toLower(ch)
          inWord = true
        }
      } else if (ch == 39) {
        apos = inWord && !apos
      } else {
        apos = false
        if (inWord) {
          add(words, w)
          inWord = false
        }
      }
    }
    if (inWord) {
      add(words, w)
    }
    return words
  }
}
