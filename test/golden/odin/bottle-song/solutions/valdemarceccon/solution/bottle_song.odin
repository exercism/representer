package bottle_song
import "core:fmt"
import "core:strings"

get_number_word :: proc(n: int, upper: bool = false) -> string {
	switch n {
	case 10: return "Ten"   if upper else "ten"
	case 9:  return "Nine"  if upper else "nine"
	case 8:  return "Eight" if upper else "eight"
	case 7:  return "Seven" if upper else "seven"
	case 6:  return "Six"   if upper else "six"
	case 5:  return "Five"  if upper else "five"
	case 4:  return "Four"  if upper else "four"
	case 3:  return "Three" if upper else "three"
	case 2:  return "Two"   if upper else "two"
	case 1:  return "One"   if upper else "one"
	case:    return "No"    if upper else "no"
	}
}

recite :: proc(start, repeat: int) -> []string {
	ret : [dynamic]string
	
	for i in 0..<repeat {
		if len(ret) > 0 {
			append(&ret, "")
		}

		n := start - i
		n_str := get_number_word(n, upper = true)

		rest_str := get_number_word(n-1)

		n_bottle := "bottle" if n == 1 else "bottles"
		rest_bottle := "bottle" if n - 1 == 1 else "bottles"

		l1 := fmt.aprintf("%s green %s hanging on the wall,", n_str, n_bottle)
		l2 := strings.clone(l1)
		l3 := fmt.aprintf("%s", "And if one green bottle should accidentally fall,")
		l4 := fmt.aprintf("There'll be %s green %s hanging on the wall.", rest_str, rest_bottle)

		append(&ret, l1)
		append(&ret, l2)
		append(&ret, l3)
		append(&ret, l4)
	}
	return ret[:]
}
