{
  count_words: (sentence) ->
    counts = {}
    for word in sentence\lower!\gmatch "[%w']+"
      trimmed = word\match "^%W*(.-)%W*$"
      counts[trimmed] = (counts[trimmed] or 0) + 1 unless #trimmed == 0
    counts
}
