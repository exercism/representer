{
  count_words: (s) ->
    -- need lowercase only
    s = s\lower!
    -- eliminate non-letters except '
    s = s\gsub "[^%w']", ' '
    -- remove "'" not surrounded by letters
    s = " #{s} "
    s = s\gsub " '+", ' '
    s = s\gsub "'+ ", ' '

    with res = {}
      for w in s\gmatch '[^ ]+'
        res[w] = (res[w] or 0) + 1
}
