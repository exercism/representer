vim9script

# Convert a sequence of digits representing a number in the input base to a
# sequence of digits in the output base.
# 
# Input and output bases must be >= 2.
# All digits in the sequence must be positive but less than the input base. 
#
# Examples:
#   :echo Rebase([1, 0, 1], 2, 10)
#   [5]
def g:Rebase(digits: list<number>,
             inputBase: number,
             outputBase: number): list<number>
    if inputBase < 2
        throw 'input base must be >= 2'
    endif
    if outputBase < 2
        throw 'output base must be >= 2'
    endif
    # Collect the digits into an integer that we can perform arithmetic on.
    var intermediate = 0
    for digit in digits
        if digit < 0 || inputBase <= digit
            throw 'all digits must satisfy 0 <= d < input base'
        endif
        intermediate = digit + inputBase * intermediate
    endfor
    # Convert the integer to digits in the new base.
    var result = []
    while intermediate != 0
        result->add(intermediate % outputBase)
        intermediate /= outputBase
    endwhile
    return result == [] ? [0] : reverse(result)
enddef 

defcompile
