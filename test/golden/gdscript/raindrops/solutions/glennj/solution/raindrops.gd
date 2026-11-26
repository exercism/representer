func convert(number: int):
	var sounds = []

	if number % 3 == 0:
		sounds.push_back("Pling")

	if number % 5 == 0:
		sounds.push_back("Plang")

	if number % 7 == 0:
		sounds.push_back("Plong")

	if sounds.is_empty():
		sounds.push_back(str(number))

	return "".join(sounds)
