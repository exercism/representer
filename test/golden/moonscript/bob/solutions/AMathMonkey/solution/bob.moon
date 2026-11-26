hey: (input) ->
  trimmed = input\gsub('^%s+', '')\gsub('%s+$', '')
  return 'Fine. Be that way!' if #trimmed == 0
  yelling = trimmed\find('[A-Z]') and not trimmed\find('[a-z]')
  question = trimmed\find('?$')
  if yelling and question then 'Calm down, I know what I\'m doing!'
  else if yelling then 'Whoa, chill out!'
  else if question then 'Sure.'
  else 'Whatever.'
