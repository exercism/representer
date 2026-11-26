function bs(array, value, range)
    f,l = first(range), last(range)
    len = length(range)
    if len == 0
        return f:l
    elseif len == 1
        value == array[f] && return f:f
        return f:f-1
    elseif len == 2
        array[f] == value && return f:f
        array[l] == value && return l:l
        return l:f
    end
    
    ind = convert(Int, f+floor((len/2)))

    if array[ind] > value
        range = f:(ind-1)
    elseif array[ind] < value
       range = (ind+1):l
    else
        return ind:ind
    end
    bs(array, value, range)
end

function binarysearch(array, value)
    return bs(array, value, 1:length(array))
end