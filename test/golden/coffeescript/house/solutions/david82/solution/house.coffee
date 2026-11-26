class House
  # Define the subjects and their actions for each verse
  @VERSE_DATA = [
    { subject: 'house that Jack built', action: null }
    { subject: 'malt', action: 'lay in' }
    { subject: 'rat', action: 'ate' }
    { subject: 'cat', action: 'killed' }
    { subject: 'dog', action: 'worried' }
    { subject: 'cow with the crumpled horn', action: 'tossed' }
    { subject: 'maiden all forlorn', action: 'milked' }
    { subject: 'man all tattered and torn', action: 'kissed' }
    { subject: 'priest all shaven and shorn', action: 'married' }
    { subject: 'rooster that crowed in the morn', action: 'woke' }
    { subject: 'farmer sowing his corn', action: 'kept' }
    { subject: 'horse and the hound and the horn', action: 'belonged to' }
  ]

  @verse: (number) ->
    # Build the verse by accumulating parts
    parts = []
    
    # Start with "This is the" and the subject
    parts.push "This is the #{@VERSE_DATA[number - 1].subject}"
    
    # Add all the previous verses' actions and subjects in reverse order
    # Stop at index 1 (not 0) to avoid undefined error
    if number > 1
      for i in [number - 1..1]
        action = @VERSE_DATA[i].action
        prevSubject = @VERSE_DATA[i - 1].subject
        
        if action
          parts.push "that #{action} the #{prevSubject}"
    
    # Join all parts with spaces and add period at the end
    parts.join(' ') + '.'

  @verses: (startVerse, endVerse) ->
    # Generate all verses in the range and join with newlines
    verses = []
    for i in [startVerse..endVerse]
      verses.push @verse(i)
    verses.join '\n'

module.exports = House
