public function keep(sequence seq, atom f)
    sequence result = {}
    for i = 2 to length(seq) do
        if call_func(f, {seq[i]}) then
            result = append(result, seq[i])
        end if
    end for
    return result
end function

public function discard(sequence seq, atom f)
    sequence result = {}
    for i = 1 to length(seq) do
        if not call_func(f, {seq[i]}) then
            result = append(result, seq[i])
        end if
    end for
    return result
end function
