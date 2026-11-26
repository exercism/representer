func clean(number: String) -> Variant:
	var sanitized := ""
	
	for c in number:
		if c.is_valid_int():
			sanitized += c
			
	if sanitized.length() == 11 and sanitized[0] == "1":
		sanitized = sanitized.trim_prefix("1")
		
	if sanitized.length() > 10 or sanitized.length() < 10 or \
		sanitized[0] == "0" or sanitized[0] == "1" or \
		sanitized[3] == "0" or sanitized[3] == "1":
		return null

	return sanitized
