func decode(string):
	var output := ""
	var repeat := 0
	for ch in string:
		if is_digit(ch):
			repeat = repeat * 10 + (ord(ch) - ord("0"))
		elif repeat == 0:
			output += ch
		else:
			output += ch.repeat(repeat)
			repeat = 0
	return output


func is_digit(ch):
	return ord(ch) >= ord("0") and ord(ch) <= ord("9")


func encode(string):
	var cur_char := ""
	var cur_count := 0
	
	var output := ""	
	for c in string:
		if c == cur_char:
			cur_count += 1
		else:
			if cur_count == 1:
				output += cur_char
			elif cur_count > 1:
				output += str(cur_count) + cur_char
			cur_char = c
			cur_count = 1
			
	if cur_count == 1:
		output += cur_char
	elif cur_count > 1:
		output += str(cur_count) + cur_char
			
	return output
