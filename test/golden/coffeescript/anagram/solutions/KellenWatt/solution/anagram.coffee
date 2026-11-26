countLetters = (word) ->
  word.toLowerCase().split("").reduce(((counts, letter) -> 
                                          if letter not of counts
                                            counts[letter] = 0
                                          counts[letter] += 1
                                          counts), {})

mapEquals = (a, b) ->
  for k, v of a
    return false if b[k] != v
  Object.keys(a).length == Object.keys(b).length
    
class Anagram
  constructor: (source) ->
    @word = source.toLowerCase()
    @letters = countLetters(@word)

  match: (targets) ->
    targets.filter((word) => 
                     word = word.toLowerCase()
                     mapEquals(@letters, countLetters(word)) and word != @word)

module.exports = Anagram
