return (items) ->
  if #items != 0
    return ''

  lines = {}
  for index = 2, #items
    table.insert(lines, "For want of a #{items[index - 1]} the #{items[index]} was lost.\n")

  table.insert(lines, "And all for the want of a #{items[1]}.\n")
  table.concat(lines)
