module main

fn rotate(text string, shift_key int) string {
	mut res := []u8{}
	for c in text {
		if c in [` `, `'`, `,`, `.`, `!`] {
			res << c
			continue
		}
		if c.is_digit() {
			res << c
			continue
		}
		t := u8(c + shift_key)
		if c >= `a` && c <= `z` {
			res << if t > `z` { t - 26 } else { t }
		}
		if c >= `A` && c <= `Z` {
			res << if t > `Z` { t - 26 } else { t }
		}
	}
	return res.bytestr()
}
