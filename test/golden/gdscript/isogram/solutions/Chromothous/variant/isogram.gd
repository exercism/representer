func is_isogram(string: String):
	for i in string:
    	if string.to_lower().count(i) > 1 or i in "abcdefghijklmnopqrstuvwxyz":
        	return false

    return true
