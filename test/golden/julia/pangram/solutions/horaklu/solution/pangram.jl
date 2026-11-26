"""
    ispangram(input)

Return `true` if `input` contains every alphabetic character (case insensitive).

"""
function ispangram(input)
    if input == ""
        return false
    end
    result = fill(0, 26)
    for c in lowercase(input)
        if 'a' <= c <= 'z'
            idx = c - 'a' + 1
            result[idx] += 1
        end
    end
    return all(x -> x > 0, values(result))
end
