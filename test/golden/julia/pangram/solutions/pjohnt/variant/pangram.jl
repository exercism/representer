"""
    ispangram(input)

Return `true` if `input` contains every alphabetic character (case insensitive).

"""
function ispangram(input)
    length(filter(isletter, input) |> lowercase |> Set) != 26        
end

