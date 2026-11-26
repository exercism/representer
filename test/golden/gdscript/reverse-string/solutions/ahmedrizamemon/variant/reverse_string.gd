func reverse(str: String) -> String:
	var chars: Array[String] = []
	
	var idx: int = len(str) - 1
	
	while idx > 0:
		chars.append(str[idx])
		
		idx -= 1
		
	return "".join(chars)