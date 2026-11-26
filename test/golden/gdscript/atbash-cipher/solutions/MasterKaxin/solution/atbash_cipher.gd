var ALPHABET = "abcdefghijklmnopqrstuvwxyz"
var REVERSED_ALPHABET = ALPHABET.reverse()

func encode(plain_text):
	var text = plain_text.to_lower()
	var lettercount: int = 0
	var ciphered_text: String
	var letterpostion: int = 0
	for current_character in text:
		if lettercount % 5 == 0 and lettercount != 0 and is_valid_atbashcipher_character(current_character):
			ciphered_text += " "
		if is_valid_atbashcipher_character(current_character):
			if current_character.is_valid_int():
				ciphered_text += current_character
				lettercount += 1
			else:
				letterpostion = ALPHABET.find(current_character)
				ciphered_text += REVERSED_ALPHABET[letterpostion]
				lettercount += 1
	return ciphered_text
	

func decode(ciphered_text):
	var text = ciphered_text.to_lower()
	var decoded_text: String
	var letterposition: int = 0
	for current_character in text:
		if is_valid_atbashcipher_character(current_character):
			if is_valid_alphabet_character(current_character):
				letterposition = REVERSED_ALPHABET.find(current_character)
				decoded_text += ALPHABET[letterposition]
			else:
				decoded_text += current_character
	return decoded_text


func is_valid_alphabet_character(character: String) -> bool:
	return ALPHABET.find(character) != -1

func is_valid_atbashcipher_character(character: String) -> bool:
	return is_valid_alphabet_character(character) or character.is_valid_int()

