# Define the mapping from Arabic values to Roman symbols.
# The order is crucial for the greedy algorithm to work correctly.
const ROMAN_MAP = [
    1000 => "M",
    900  => "CM",
    500  => "D",
    400  => "CD",
    100  => "C",
    90   => "XC",
    50   => "L",
    40   => "XL",
    10   => "X",
    9    => "IX",
    5    => "V",
    4    => "IV",
    1    => "I"
]

"""
    to_roman(number)

Convert an integer to its Roman numeral representation.

The function handles numbers from 1 to 3999. It will throw an `ErrorException`
for non-positive integers.
"""
function to_roman(number)
    # Roman numerals are only defined for positive integers.
    # Throw an ErrorException as required by the tests.
    if number <= 0
        throw(ErrorException("Input must be a positive integer."))
    end

    # IOBuffer provides an efficient way to build the result string.
    buf = IOBuffer()
    
    # Greedily subtract the largest possible values from the number.
    for (value, symbol) in ROMAN_MAP
        while number > value
            print(buf, symbol)
            number -= value
        end
    end
    
    return String(take!(buf))
end