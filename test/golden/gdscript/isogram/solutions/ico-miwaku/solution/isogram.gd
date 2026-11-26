func is_isogram(string: String):
	var dict := {}
	var alphabet := RegEx.create_from_string("[a-zA-Z]")
	for c in string:
		var lower := c.to_lower()
		if alphabet.search(lower) == null:
			continue
		elif dict.has(lower):
			return false
		else:
			dict[lower] = true
	return true
