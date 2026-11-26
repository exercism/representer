public function largestProduct(sequence digits, integer span)
    if span <= 0 or span > length(digits) then
        return -1
    end if

    if span = 0 then
        return 1
    end if

    integer max_product = 0

    for i = 1 to length(digits) - span + 1 do
        integer product = 1

        for j = 0 to span - 1 do
            integer digit = digits[i + j] - '0'
            if digit < 0 or digit > 9 then
                return -1
            end if
            product *= digit
        end for

        if product > max_product then
            max_product = product
        end if
    end for

    return max_product
end function
