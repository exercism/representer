func is_pangram(sentence: String) -> bool:
	var dict := {}
	var alphabet := RegEx.create_from_string("[a-zA-Z]")
	for c in sentence:
		var lower := c.to_lower()
		if alphabet.search(lower) == null:
			dict[lower] = true
	return dict.size() == 26
