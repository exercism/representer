import sequtils

proc pascal*(i: int) : seq[seq[int]] =

  result = newSeqWith(i, newSeqOfCap[int](0))
  for row in 0..<i:
    for val in 0..row:
      if val >= 0 and val < row :
        result[row].add(result[row-1][val-1]+result[row-1][val])
      else:
        result[row].add(1)