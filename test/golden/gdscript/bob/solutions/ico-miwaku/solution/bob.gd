var question_pattern := RegEx.create_from_string("\\?\\s*$")
var has_letter := RegEx.create_from_string("[a-zA-Z]")
var spaces_only := RegEx.create_from_string("^\\s+$")


func response(message: String) -> String:
	var question := question_pattern.search(message) != null
	var yelling := has_letter.search(message) != null and \
		message == message.to_upper()
	var spaces_only := spaces_only.search(message) != null


	if question and yelling:
		return "Calm down, I know what I'm doing!"
	elif question:
		return "Sure."
	elif yelling:
		return "Whoa, chill out!"
	elif spaces_only or message == "":
		return "Fine. Be that way!"
	else:
		return "Whatever."
