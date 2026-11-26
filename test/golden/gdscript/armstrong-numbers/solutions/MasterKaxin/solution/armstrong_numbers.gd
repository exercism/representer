func is_armstrong_number(number: int) -> bool:
	var calc: int = 0
	var digit_count: int = str(number).length()
	for str_digit in str(number):
		calc += pow(str_digit.to_int(), digit_count)
	return calc == number