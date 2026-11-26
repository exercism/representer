func is_pangram(sentence):
	if sentence == "":
    	return false

	var pure_sentence = sentence.to_lower()
	var alpha_string = "abcdefghijklmnopqrstuvwxyz"

    for i in alpha_string:
    	if pure_sentence.count(i) < alpha_string.count(i):
        	return false

    return true
