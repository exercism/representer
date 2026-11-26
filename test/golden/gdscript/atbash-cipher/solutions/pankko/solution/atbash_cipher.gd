func encode(plain_text):
	var alphabet = "abcdefghijklmnopqrstuvwxyz1234567890"
	var cipher_letters = "zyxwvutsrqponmlkjihgfedcba1234567890"
	var encoded_text = ""
    var wordcount = 0
	plain_text = plain_text.to_lower().replace(" ","")

	for c in plain_text:
    	var letter_pos = alphabet.find(c)
        if alphabet.contains(c):
        	encoded_text = encoded_text.insert(encoded_text.length() ,cipher_letters[letter_pos])
        	wordcount += 1
        	if wordcount == 5:
        		encoded_text = 	encoded_text.insert(encoded_text.length(), " ")
            	wordcount = 0
    encoded_text = encoded_text.strip_edges()
    return encoded_text
	pass

func decode(ciphered_text):
	var alphabet = "abcdefghijklmnopqrstuvwxyz1234567890"
	var cipher_letters = "zyxwvutsrqponmlkjihgfedcba1234567890"
    var decoded_text = ""

    for c in ciphered_text:
    	var ciphered_letter_pos = cipher_letters.find(c)
    	if cipher_letters.contains(c):
        	decoded_text = decoded_text.insert(decoded_text.length(), alphabet[ciphered_letter_pos])
    decoded_text = decoded_text.strip_edges()
    return decoded_text
	pass
