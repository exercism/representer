@export var card_num : String


func valid():
	var sanitized := ""
	
	for c in card_num:
		if c.is_valid_int():
			sanitized += c
		elif c != " ":
			return false

	if sanitized == "0":
		return false

	var sum := 0
	
	for i in sanitized.length():
		var j := sanitized.length() - i - 1
		
		if not sanitized[j].is_valid_int():
			return false
		
		var n := int(sanitized[j])
		
		if i % 2 == 1:
			n *= 2
			if n > 9:
				n -= 9
				
		sum += n

	return sum % 10 == 0
