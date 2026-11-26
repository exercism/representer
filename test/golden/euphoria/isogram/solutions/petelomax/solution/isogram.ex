include sort.e
include wildcard.e
public function isogram( sequence str )
    str = sort(lower(str))
    for i=2 to length(str) do
        if str[i] = str[i-1] and not find(str[i]," -") then
            return 0
        end if
    end for
    return 1
end function
