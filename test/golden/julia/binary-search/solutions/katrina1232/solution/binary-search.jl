function binarysearch(list, key)
    found = false
    fail = false
    beginning = 1
    ending = length(list) 
    i = 1
    if list == []
        return 1:0
    end
    while !found && !fail
        len = ending - beginning
        i = beginning + (len ÷ 2)
        if list[i] == key
            found = true
        elseif len > 1
            (list[i] > key) ? (ending = i - 1) : (beginning = i + 1)
        else
            fail = true
        end
    end
    return found ? (i:i) : (i:i-1) 
end