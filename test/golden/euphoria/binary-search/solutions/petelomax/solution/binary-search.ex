public function my_find(sequence list, atom key)
    integer lo = 1, hi = length(list)
    while lo<=hi do
        integer mid = floor((lo+hi)/2)
        switch compare(key,list[mid]) do
            case -1 then hi = mid-1
            case  0 then return mid  -- found!
            case +1 then lo = mid+1
        end switch
    end while
    return -1
end function
