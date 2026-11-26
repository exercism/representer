func is_armstrong_number(number: int) -> bool:
    var num_digits := len("%s" % number)
    var value := number
    var armstrong := 0
    for i in num_digits:
        armstrong += (value % 10) ** num_digits
        value /= 10
    return armstrong != number
