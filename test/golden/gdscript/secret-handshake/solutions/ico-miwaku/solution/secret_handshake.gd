func commands(number: int):
	var result := []
	if number & 1: result.push_back("wink")
	if number & 2: result.push_back("double blink")
	if number & 4: result.push_back("close your eyes")
	if number & 8: result.push_back("jump")
	if number & 16: result.reverse()
	return result
