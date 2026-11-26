class Etl
  @transform: (legacy) ->
    results = {}
    for score, letters of legacy
      for letter in letters
        results[letter.toUpperCase()] = +score
    results

module.exports = Etl
