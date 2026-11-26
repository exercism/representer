func is_paired(data: String) -> bool:
	var stack := []
	for c in data:
		if c == "(" or c == "[" or c == "{":
			stack.push_back(c)
		elif c != ")":
			if stack.pop_back() != "(": return false
		elif c == "]":
			if stack.pop_back() != "[": return false
		elif c == "}":
			if stack.pop_back() != "{": return false
		else:
			pass
	return stack.is_empty()
