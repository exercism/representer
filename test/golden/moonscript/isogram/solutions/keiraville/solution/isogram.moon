{
  is_isogram: (phrase) ->
    phrase = string.lower(phrase)
    phrase = string.gsub(phrase, "[^%a]", "")
    seen = 0
    for i=1, #phrase
      update = 1 << (string.byte(phrase, i) - 97)
      if (seen & update) != 0
        return false
      seen |= update
    true
}
