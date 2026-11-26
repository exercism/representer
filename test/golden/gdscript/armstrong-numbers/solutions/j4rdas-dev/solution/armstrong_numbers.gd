func is_armstrong_number(number):
	var s_number = str(number)
	var l_number = s_number.length()
	var arm_number = 0
	for i in range(l_number):
		arm_number += pow(int(s_number[i]), l_number)
	if number == arm_number:
		return true
	else:
		return false