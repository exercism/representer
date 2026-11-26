{
    print is_valid($0) ? "true" : "false"
}

function is_valid(string) {
    gsub(/[[:space:]]/, "", string)
        
    if(1 >= length(string) || contains_only_digit(string) ) return 0

    split(string, digits, //)
    digit_must_be_mapped = 1
    for(i = length(digits); i >= 1; --i) {
        digit_must_be_mapped = !digit_must_be_mapped
        if(digit_must_be_mapped) {
            digits[i] = map_to_luhn_digit(digits[i])
        }
    
        sum = sum + digits[i]
    }

    return 0 == sum % 10
}

function contains_only_digit(string) {
    return string ~ /[^[:digit:]]/
}

function map_to_luhn_digit(digits) {
    return 9 != digits ? (digits * 2) % 9 : 9
}
