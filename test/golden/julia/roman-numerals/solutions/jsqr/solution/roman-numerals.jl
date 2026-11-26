symbols = Dict(
    1 => "I",
    4 => "IV",
    5 => "V",
    9 => "IX",
    10 => "X",
    40 => "XL",
    50 => "L",
    90 => "XC",
    100 => "C",
    400 => "CD",
    500 => "D",
    900 => "CM",
    1000 => "M"
)

function to_roman(number)
    if number <= 0
        throw(ErrorException("Number must be positive"))
    end
    ks = sort(collect(keys(symbols)), rev=true)
    roman = ""
    for k in ks
        while number >= k
            roman *= symbols[k]
            number -= k
        end
    end
    return roman
end
