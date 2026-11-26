include std/math.e
include std/sort.e

public function latest(sequence scores)
  return scores[$]
end function

public function personal_best(sequence scores)
  return max(scores)
end function

public function personal_top_three(sequence scores)
  sequence sorted = sort(scores, DESCENDING)
  if length(sorted) >= 3 then
    return sorted[1..3]
  else
    return sorted
  end if
end function
