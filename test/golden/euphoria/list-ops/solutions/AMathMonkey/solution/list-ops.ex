public function my_append(sequence seq1, sequence seq2)
  sequence result = {}
  for i = 1 to length(seq1) do
    result = append(result, seq1[i])
  end for
  for i = 1 to length(seq2) do
    result = append(result, seq2[i])
  end for
  return result
end function

public function my_concatenate(sequence seq)
  sequence result = {}
  for li = 1 to length(seq) do
    sequence list = seq[li]
    for i = 1 to length(list) do
      result = append(result, list[i])
    end for
  end for
  return result
end function

public function my_filter(sequence seq, integer fn)
  sequence result = {}
  for i = 1 to length(seq) do
    if call_func(fn, {seq[i]}) then result = append(result, seq[i]) end if
  end for
  return result
end function

public function my_length(sequence seq)
  integer result = 0
  while not equal(seq, {}) do
    seq = remove(seq, 1)
    result += 1
  end while
  return result
end function

public function my_map(sequence seq, integer fn)
  sequence result = {}
  for i = 1 to length(seq) do
    result = append(result, call_func(fn, {seq[i]}))
  end for
  return result
end function

public function my_foldl(sequence seq, integer fn, object initial)
  object result = initial
  for i = 1 to length(seq) do
    result = call_func(fn, {result, seq[i]})
  end for
  return result
end function

public function my_foldr(sequence seq, integer fn, object initial)
  object result = initial
  for i = length(seq) to 1 by -1 do
    result = call_func(fn, {seq[i], result})
  end for
  return result
end function

public function my_reverse(sequence seq)
  sequence result = {}
  for i = length(seq) to 1 by -1 do
    result = append(result, seq[i])
  end for
  return result
end function
