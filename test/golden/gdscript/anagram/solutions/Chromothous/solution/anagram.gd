func find_anagram(word, candidates):
	var holding_list = []
	
	# Clean the target word: lowercase it and sort its letters
	var lower_word = word.to_lower()
	var sorted_word = lower_word.split("")
	sorted_word.sort()
	
	for candidate in candidates:
		var lower_candidate = candidate.to_lower()
		
		# 1. Anagrams must be the exact same length
		if lower_word.length() != lower_candidate.length():
			continue
			
		# 2. A word is NOT an anagram of itself
		if lower_word == lower_candidate:
			continue
			
		# 3. Sort the candidate's letters and compare
		var sorted_candidate = lower_candidate.split("")
		sorted_candidate.sort()
		
		if sorted_word == sorted_candidate:
			holding_list.append(candidate) # Fixed the typo 'appnd'
			
	return holding_list

        
