func encode(numbers: Array):
	var result := []
	for n in numbers:
		if n == 0:
			result.append(0)
			continue
		
		var bytes := []
		var v : int = n
		while v > 0:
			bytes.push_front(v & 0x7f | 0x80)
			v >>= 7
		bytes[bytes.size() - 1] &= 0x7f
		result.append_array(bytes)

	return result


func decode(encoded: Array):
	var result := []
	var current := 0
	for byte in encoded:
		if byte & 0x80 == 0:
			current = current * 128 + byte
			result.append(current)
			current = 0
		else:
			current = current * 128 + (byte & 0x7f)
	return result if result.size() > 0 else null
