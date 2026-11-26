include wildcard.e

public function acronym(sequence s)
    sequence res = ""
    integer last_space = 1, is_space
    s = upper(s)
    for i=1 to length(s) do
        is_space = find(s[i]," _-")!=0
        if last_space and not is_space then
            res &= s[i]
        end if
        last_space = is_space
    end for
    return res
end function
