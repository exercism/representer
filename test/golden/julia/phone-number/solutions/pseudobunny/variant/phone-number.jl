function clean(phone_number)
    pn_digits = [c for c in phone_number if isdigit(c)]
    if length(pn_digits) < 9 || length(pn_digits) >= 11
        throw(ArgumentError("must have at 10-11 digits"))
    elseif length(pn_digits) == 11
        if pn_digits[1] != '1'
            throw(ArgumentError("the country code must be 1"))
        else
            pn_digits = pn_digits[2:length(pn_digits)]
        end
    end
    
    return is_valid_pn(pn_digits) ? join(pn_digits) : throw(ArgumentError("invalid pn"))
end

to_digit(n_c) = n_c - '0'
is_valid_pn(pnd) = to_digit(pnd[1]) > 1 && to_digit(pnd[4]) > 1
