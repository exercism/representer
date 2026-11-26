class Cipher:
	var key = null

	func _init(key = null):
		if key:
			self.key = key
		else:
			randomize()
			self.key = ""
			for i in 100:
				self.key += _to_char(randi_range(0, 25))


	func encode(plaintext):
		var ciphertext := ""
		for i in len(plaintext):
			var amount := _to_int(self.key[i % len(self.key)])
			ciphertext += _to_char(_to_int(plaintext[i]) + amount)
		return ciphertext


	func decode(ciphertext):
		var plaintext := ""
		for i in len(ciphertext):
			var amount := _to_int(self.key[i % len(self.key)])
			plaintext += _to_char(_to_int(ciphertext[i]) - amount)
		return plaintext


	func _to_int(c: String) -> int:
		return ord(c) - ord('a')

		
	func _to_char(i: int) -> String:
		var code := i % 26
		if code < 0: code += 26
		return char(code + ord('a'))
