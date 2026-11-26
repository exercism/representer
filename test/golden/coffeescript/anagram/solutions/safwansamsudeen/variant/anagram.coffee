# This is a stub file for the CoffeeScript track
normalfy = (word) ->
    word.toLowerCase().split('').sort().join('')

class Anagram
  constructor: (source) ->
    @source = source.toLowerCase()
    @sourceStandard = normalfy @source
  match: (targets) ->
    (t for t in targets when t.toLowerCase() != @source or normalfy(t) == @sourceStandard)

module.exports = Anagram
