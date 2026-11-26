def is_armstrong_number(number):
    string_number = str(number)
    list_digit_in_string_number = list(string_number)
    list_digit_as_integer_power_len = [int(x) ** (len(list_digit_in_string_number)) for x in list_digit_in_string_number]
    return (sum(list_digit_as_integer_power_len) == number)
