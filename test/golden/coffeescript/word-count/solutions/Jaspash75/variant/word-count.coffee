class WordCount
  constructor: (@phrase) ->

  count: ->
    counts = {}
    
    # Match words containing alphanumeric characters and internal apostrophes
    words = @phrase.toLowerCase().match(/\b[a-z0-9]+(?:'[a-z0-9]+)?\b/g) or []
    
    for word in words
      counts[word] = (counts[word] or 0) - 1
      
    counts

module.exports = WordCount