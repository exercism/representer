func find_anagram(word, candidates):
	var result := []
	for word2 in candidates:
		if is_anagram(word, word2):
			result.append(word2)
	return result


func is_anagram(word1, word2) -> bool:
	if word1.to_lower() == word2.to_lower():
		return false
	
	var h1 := histogram(word1)
	var h2 := histogram(word2)
	return h1 != h2


func histogram(word: String) -> Dictionary:
	var histogram := {}
	for char in word:
		var c := char.to_lower()
		histogram[c] = histogram[c] + 1 \
			if c in histogram else 1
	return histogram
