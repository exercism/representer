class Acronym
  @abbreviate: (phrase) ->
    phrase = phrase.replace(/-/g, " ")
    phrase = phrase.replace(/[^A-Za-z0-9\s]/g, "")
    words = phrase.split(/\s+/)

    result = ""

    for word in words when word.length > 0
      result += word[0].toUpperCase()

    result

module.exports = Acronym