func is_armstrong_number(number):
    var tot = 0
	var num_str = str(number)
    for num in num_str:
        tot += int(num) ** num_str.length()
    if tot == number:
        return true
    return false