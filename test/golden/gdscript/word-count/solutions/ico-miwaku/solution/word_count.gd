func count_words(sentence: String):
	var table := {}
	for word in split_words(sentence):
		table[word] = table[word] + 1 if word in table else 1
	return table


func split_words(sentence: String) -> Array:
	var words := []
	var i := 0
	var acc := ""
	var in_quote := false
	
	while i < sentence.length():
		match sentence[i]:
			var c when is_valid(sentence, i):
				acc += c
			"'" when in_quote and is_valid(sentence, i + 1):
				acc += "'"
			"'" when in_quote:
				in_quote = false
				if acc != "": words.push_back(acc)
				acc = ""
			"'" when is_valid(sentence, i + 1) and acc != "":
				acc += "'"
			"'":
				in_quote = true
			_ when acc != "":
				words.push_back(acc)
				acc = ""
		i += 1

	if acc != "": words.push_back(acc)
	
	for j in words.size():
		words[j] = words[j].to_lower()
		
	return words


var alphabet := RegEx.create_from_string("[a-zA-Z0-9]")


func is_valid(str: String, index: int) -> bool:
	if index < 0 or index >= str.length():
		return false
	return alphabet.search(str[index]) != null
