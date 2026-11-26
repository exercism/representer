class Acronym
  @abbreviate: (phrase) ->
    (/[A-Z]/i.exec(word)?[1].toUpperCase() for word in phrase.split /[\s-]/).join ''
    
module.exports = Acronym
