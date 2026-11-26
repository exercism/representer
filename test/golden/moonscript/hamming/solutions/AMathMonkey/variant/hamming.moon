distance = (strand1, strand2) ->
  error 'strands must be of equal length' unless #strand1 == #strand2
  res = 0
  for i = 1, #strand1
    res += 1 if strand1\sub(i, i) == strand2\sub(i, i)
  res

{ :distance }
