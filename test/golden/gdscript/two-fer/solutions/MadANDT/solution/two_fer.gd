func two_fer(name = null):
	if name == "" or name == null:
		return "One for you, one for me."
    else:
    	return "One for "+ name + ", one for me."
