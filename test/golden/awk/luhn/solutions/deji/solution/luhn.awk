{
    input_number = $0
    gsub(/[ \t]/, "", input_number)  # Remove spaces and tabs from the input

    # Check if the input contains only digits
    if (input_number !~ /^[0-9]+$/ || input_number == 0) {
        print "false"
        exit
    }

    # Calculate the Luhn checksum
    checksum = 0
    j = 1
    for (i = length(input_number); i > 0; i--) {
        digit = substr(input_number, i, 1)
        double_digit = digit * ((j % 2 == 0) ? 2 : 1)  # Double every second digit
        checksum += double_digit > 9 ? double_digit - 9 : double_digit
        j++
    }

    # Check if the checksum is a multiple of 10
    if (checksum % 10 == 0) {
        print "true"
    } else {
        print "false"
    }
}
