square_root = (radicand) ->
  x = 0
  while x * x <= radicand
    x += 1
  x

{ sqrt: square_root }
