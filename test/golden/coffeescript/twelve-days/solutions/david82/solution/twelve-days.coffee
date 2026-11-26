class TwelveDays
  # Define the ordinal numbers
  @ordinals = [
    'first', 'second', 'third', 'fourth', 'fifth', 'sixth',
    'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth'
  ]
  
  # Define the gifts for each day
  @gifts = [
    'a Partridge in a Pear Tree.',
    'two Turtle Doves,',
    'three French Hens,',
    'four Calling Birds,',
    'five Gold Rings,',
    'six Geese-a-Laying,',
    'seven Swans-a-Swimming,',
    'eight Maids-a-Milking,',
    'nine Ladies Dancing,',
    'ten Lords-a-Leaping,',
    'eleven Pipers Piping,',
    'twelve Drummers Drumming,'
  ]
  
  # Generate a single verse
  @verse: (day) ->
    # Start with the opening line
    lines = ["On the #{@ordinals[day - 1]} day of Christmas my true love gave to me:"]
    
    # Add gifts in reverse order (from current day down to day 1)
    for i in [day - 1..0] by -1
      gift = @gifts[i]
      # Special handling for day 1 when it's not the only gift
      if i == 0 and day > 1
        gift = 'and ' + gift
      lines.push gift
    
    # Join all parts with spaces
    lines.join ' '
  
  # Recite verses from startVerse to endVerse
  @recite: (startVerse, endVerse) ->
    verses = []
    for verse in [startVerse..endVerse]
      verses.push @verse(verse)
    verses.join '\n'

module.exports = TwelveDays
