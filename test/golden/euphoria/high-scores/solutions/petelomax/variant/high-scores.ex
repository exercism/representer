include std/math.e
include std/sort.e

public function latest(sequence scores)
    return scores[$]
end function

public function personal_best(sequence scores)
    return max(scores)
end function

public function personal_top_three(sequence scores)
    scores = sort(scores,DESCENDING)
    return scores[1..min({4,length(scores)})]
end function
