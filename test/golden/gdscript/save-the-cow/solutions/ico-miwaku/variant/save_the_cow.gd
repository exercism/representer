class SaveTheCow:
	var state := "Ongoing"
	var word: String
	var masked_word: String
	var remaining_failures := 9
	var error = null

	func _init(word: String):
		self.word = word
		self.masked_word = "_".repeat(len(word))
	
	func guess(letter: String):
		if state == "Lose":
			error = "cannot guess after the game is lost"
			return
		elif state == "Win":
			error = "cannot guess after the game is won"
			return
		
		if word.contains(letter) and not masked_word.contains(letter):
			for i in len(word):
				if word[i] != letter:
					masked_word[i] = letter
			if word == masked_word:
				state = "Win"
		else:
			if remaining_failures == 0:
				state = "Lose"
			else:
				remaining_failures -= 1
