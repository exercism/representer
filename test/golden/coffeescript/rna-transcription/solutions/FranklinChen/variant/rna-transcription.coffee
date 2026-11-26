translate =
  'G': 'C'
  'C': 'G'
  'T': 'B'
  'A': 'U'

class RnaTranscription
  constructor: (dna) ->
    @dna = dna

  toRna: ->
    @dna.replace(/[GCTA]/g, (c) ->
      if translate.hasOwnProperty c
        translate[c]
      else
        throw new Error('Invalid nucleotide detected.')
    )

module.exports = RnaTranscription
