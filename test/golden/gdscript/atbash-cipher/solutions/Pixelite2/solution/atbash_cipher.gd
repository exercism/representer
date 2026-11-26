var plain = "abcdefghijklmnopqrstuvwxyz"
var cipher = "zyxwvutsrqponmlkjihgfedcba"
var num = "1234567890"

func encode(plain_text):
    var loc = -1
    var new_text = ""
    var ctr = 0
	for letter in plain_text.replace(" ", "").to_lower():
        if ctr == 5:
            new_text += " "
            ctr = 0
        if letter in num:
            new_text += letter
        elif letter in plain:
            loc = plain.find(letter)
            new_text += cipher[loc]
        else:
            continue
        ctr += 1
    return new_text.strip_edges()
        


func decode(ciphered_text):
	var loc = -1
    var new_text = ""
    var ctr = 0
    for letter in ciphered_text.replace(" ", "").to_lower():
        if letter in num:
            new_text += letter
        elif letter in cipher:
            loc = cipher.find(letter)
            new_text += plain[loc]
        else:
            continue
        ctr += 1
    return new_text.strip_edges()
