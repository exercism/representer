isAlnum = (c) ->
    return false unless c?
    c = c.charCodeAt(0)
    (48 <= c <= 57) or (65 <= c <= 90) or (97 <= c <= 122)

isBlank = (s) -> s.trim().length == 0
    
class WordCount
  constructor: (@text) ->

  count: ->
    # Caching. Not necessary, but I like doing it for these single-use processing objects.
    unless @words? 
      text = @text.toLowerCase()
      prevBreak = 0
      @words = []
      for c,i in text
        unless isAlnum(c) or
               c == "'" and isAlnum(text[i-1]) and isAlnum(text[i+1])
          @words.push(text[prevBreak...i])
          prevBreak = i+1

      @words.push(text[prevBreak..-1])

    counts = {}
    for word in @words
      continue if isBlank(word)
      unless counts[word]?
        counts[word] = 0
      counts[word] += 1

    counts
        
    

module.exports = WordCount
