class WordCount
  constructor: (@text) ->
    
  count: ->
    # Normalize the case
    textNormalized = @text.toLowerCase()
  
    # Replace punctuation with spaces, preserving apostrophes within words
    textCleaned = textNormalized.replace /[^a-z0-9'\s]+/g, " "
  
    # Remove leading and trailing apostrophes from each word
    textCleaned = textCleaned.replace /(\s|^)'|'(\s|$)/g, "$1$2"
  
    # Split the text into words based on spaces
    words = textCleaned.trim().split /\s+/
  
    # Initialize an empty object to store word counts
    wordCounts = {}
  
    # Count each word
    for word in words
      wordCounts[word] ?= 0
      wordCounts[word] += 1
  
    return wordCounts

# Export the class for testing
module.exports = WordCount
