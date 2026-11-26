split = (str, delim) ->
  t = {}
  for delimited in string.gmatch(str .. delim, "(.-)" .. delim)
    table.insert t, delimited
  t

{
  row: (str, idx) ->
    result = {}
    for _, entry in pairs split(split(str, '\n')[idx], ' ')
      table.insert(result, tonumber entry)
    result

  column: (str, idx) ->
    result = {}
    for _, line in pairs split(str, '\n')
      entry = split(line, ' ')[idx]
      table.insert(result, tonumber entry)
    result
}
