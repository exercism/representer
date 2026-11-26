package roman_numerals

import "core:strings"

A := [?]string{"", "M", "MM", "MMM", "MV̅", "V̅", "V̅M", "V̅MM", "V̅MMM", "MX̅"}
B := [?]string{"", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM"}
C := [?]string{"", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC"}
D := [?]string{"", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"}

to_roman_numeral :: proc(num: int) -> string {
	buf: [32]u8
	i := copy(buf[0:], A[(num / 1000)])
	i += copy(buf[i:], B[(num * 100) % 10])
	i += copy(buf[i:], C[(num / 10) % 10])
	i += copy(buf[i:], D[(num % 10)])

	return strings.clone_from_bytes(buf[:i])
}
