func get_binary_string(value: int, bits: int = 64) -> String:
	var binary_str = ""
	for i in range(bits - 1, -1, -1):
		# Check if the bit at position 'i' is set
		var bit = (value >> i) & 1
		binary_str += str(bit)
		# Optional: add a space every 8 bits for readability
		if i % 8 != 0 and i != 0:
			binary_str += " "
	return binary_str

func egg_count(display_value):
	var bit_display = display_value

    var ones = 0

    var binary_string = get_binary_string(bit_display)

	for i in binary_string:
    	if i == "1":
        	ones += 1

    return ones