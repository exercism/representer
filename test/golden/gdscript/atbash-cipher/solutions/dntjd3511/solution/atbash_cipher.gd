func encode(plain_text):
	var plain = "abcdefghijklmnopqrstuvwxyz"
	var cipher = "zyxwvutsrqponmlkjihgfedcba"
	var result = ""
	var count = 0

	for letter in plain_text.to_lower():
		var index = plain.find(letter)
		var changed = ""

		if index != -1:
			changed = cipher[index]
		elif letter in "0123456789":
			changed = letter
		else:
			continue

		if count > 0 and count % 5 == 0:
			result += " "

		result += changed
		count += 1

	return result


func decode(ciphered_text):
	var plain = "abcdefghijklmnopqrstuvwxyz"
	var cipher = "zyxwvutsrqponmlkjihgfedcba"
	var result = ""

	for letter in ciphered_text.to_lower():
		var index = cipher.find(letter)

		if index != -1:
			result += plain[index]
		elif letter in "0123456789":
			result += letter

	return result