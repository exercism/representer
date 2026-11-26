module.exports = class NucleotideCount
  constructor: (strand) ->
    @nucleotideCounts = A: 0, T: 0, G: 0, C: 0
    for nucleotide in strand
      throw 'Invalid nucleotide strand' if isNaN @nucleotideCounts[nucleotide]++

  count: (nucleotide) ->
    result = @nucleotideCounts[nucleotide]
    throw 'Invalid nucleotide' unless result?
    result
