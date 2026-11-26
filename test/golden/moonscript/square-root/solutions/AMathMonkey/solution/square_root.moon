{ 
  sqrt: (radicand) ->
    for i = 1, radicand
      return i if i * i == radicand
}
