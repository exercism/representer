func is_pangram(sentence):
	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	var s = sentence.to_upper()

	for c in s:
		alphabet = alphabet.remove_chars(c)
		if alphabet.is_empty():
			return true

	return false
