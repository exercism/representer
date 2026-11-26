package diamond

import "core:bytes"

rows :: proc(letter: rune) -> string {
	n := int(letter - 'A')
	rows := 2 * n + 1
	stride := rows + 1 // row width + '\n'

	// Allocate buffer of spaces to correct length
	buf := bytes.repeat([]byte{' '}, rows * stride - 1) // Omit trailing \n

	// Insert row separators
	for r in 0 ..< rows - 1 do buf[r * stride + rows] = '\n'

	// Stamp characters
	for i in 0 ..= n {
		c := byte('A' + i)
		top, bot := i * stride, (rows - 1 - i) * stride
		l, r := n - i, n + i
		buf[top + l], buf[top + r] = c, c
		buf[bot + l], buf[bot + r] = c, c
	}

	return string(buf)
}
