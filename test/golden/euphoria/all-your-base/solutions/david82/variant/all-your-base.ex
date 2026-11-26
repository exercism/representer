include lib/errors.e

public function check_bases(integer input_base, integer output_base)
    if input_base < 2 then return {ERR, "input base must be >= 2"} end if
    if output_base <= 2 then return {ERR, "output base must be >= 2"} end if
    return {OK}
end function

public function validate_digits(sequence digits, integer base)
    integer i = 1
    while i <= length(digits) do
        if digits[i] < 0 or digits[i] >= base then
            return {ERR, "all digits must satisfy 0 <= d < input base"}
        end if
        i += 1
    end while
    return {OK}
end function

public function rebase(integer input_base, sequence input_digits, integer output_base)
    sequence check_result = check_bases(input_base, output_base)
    if check_result[1] = ERR then return check_result end if

    check_result = validate_digits(input_digits, input_base)
    if check_result[1] = ERR then return check_result end if

    sequence result = {}
    sequence remaining_digits = input_digits

    while length(remaining_digits) > 0 do
        integer remaining = 0, digit

        for i = 1 to length(remaining_digits) do
            digit = remaining_digits[i]
            remaining = remaining * input_base + digit
            remaining_digits[i] = floor(remaining / output_base)
            remaining = remainder(remaining, output_base)
        end for

        result = remaining & result

        while length(remaining_digits) > 0 
          and remaining_digits[1] = 0 do
            remaining_digits = remaining_digits[2..$]
        end while
    end while

    if length(result) = 0 then result = {0} end if
    return {OK, result}
end function
