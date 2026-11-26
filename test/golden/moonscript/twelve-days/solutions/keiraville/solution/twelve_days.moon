ordinals = {
  'first',
  'second',
  'third',
  'fourth',
  'fifth',
  'sixth',
  'seventh',
  'eighth',
  'ninth',
  'tenth',
  'eleventh',
  'twelfth'
}

gifts = {
  'a Partridge in a Pear Tree.',
  'two Turtle Doves, and',
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
}

recite_verse = (verse) ->
  result = { 'On the', ordinals[verse], 'day of Christmas my true love gave to me:' }
  for index = verse, 1, -1 do
    table.insert(result, gifts[index])
  table.concat(result, ' ')

{
  recite: (start, stop) ->
    result = {}
    for verse=start,stop
      table.insert(result, recite_verse(verse))
    result
}
