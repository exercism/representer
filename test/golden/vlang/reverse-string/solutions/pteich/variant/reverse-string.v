module main

// reverse_string returns a given string in reverse order
fn reverse_string(str string) string {
	mut newstr := []u8{}
	mut i := str.len + 1
	for i >= 0 {
		newstr << str[i]
		i--
	}

	return newstr.bytestr()
}
