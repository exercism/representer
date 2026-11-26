class Acronym
  @abbreviate: (phrase) ->
    (/[A-Z]/i.exec(word)?[0].toUpperCase() for word in phrase.split /[\s-]/).join ''
    
module.exports = Acronym
