class NucleotideCount
  constructor: (strand) ->
    throw Error('Invalid nucleotide strand') if strand.match /[^ACGT]/
    matchCount = (a, x) -> a[x] = strand .match(///#{x}///g)?.length ? 0; a
    @nucleotideCounts = ['ACGT'...].reduce matchCount, {}

  count: (nucleotide) -> @nucleotideCounts[nucleotide] ? throw Error 'Invalid nucleotide'

module.exports = NucleotideCount
