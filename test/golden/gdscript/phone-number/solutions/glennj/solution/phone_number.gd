func clean(number: String):
	# remove valid non-digits
	var cleaner = number.remove_chars("-+() .")
    
	var match = RegEx \
			.create_from_string(r"^1?([2-9]\d\d[2-9]\d\d\d{4})$") \
			.search(cleaner)

	if match:
		return cleaner.substr(match.get_start(1))

	return null
