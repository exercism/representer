package diamond

import "core:strings"

rows :: proc(letter: rune) -> string {
	if letter == 'A' {
		return "A"
	}
	sb: strings.Builder
	width := int(letter - 'A' + 1) * 2 - 1
	for r := 'A'; r <= letter; r += 1 {
		line(&sb, width, r)
		strings.write_rune(&sb, '\n')
	}
	for r := letter - 1; r >= 'A'; r -= 1 {
		line(&sb, width, r)
		if r != 'A' do strings.write_rune(&sb, '\n')
	}
	return strings.to_string(sb)
}

line :: proc(sb: ^strings.Builder, width: int, letter: rune) {
	letter_no := letter - 'A'
	if letter_no == 0 {
		for _ in 0 ..< width / 2 do strings.write_rune(sb, ' ')
		strings.write_rune(sb, letter)
		for _ in 0 ..< width / 2 do strings.write_rune(sb, ' ')
		return
	}
	margin := (width - int(letter_no * 2 + 1)) / 2
	for _ in 0 ..< margin do strings.write_rune(sb, ' ')
	strings.write_rune(sb, letter)
	for _ in 0 ..< letter_no * 2 - 1 do strings.write_rune(sb, ' ')
	strings.write_rune(sb, letter)
	for _ in 0 ..< margin do strings.write_rune(sb, ' ')
}
