{
  row: (str, idx) ->
    i = 1
    for row_str in str\gmatch('[^\n]+')
      return [math.tointeger(s) for s in row_str\gmatch('%d+')] if i == idx
      i += 1

  column: (str, idx) ->
    return for row_str in str\gmatch('[^\n]+')
      j, n = 1, nil
      for s in row_str\gmatch('%d+')
        if j == idx
          n = math.tointeger(s)
          break
        j += 1
      n
}
