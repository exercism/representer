package raindrops

import "core:fmt"
import "core:strings"

convert :: proc(number: int) -> string {
	div3 := number % 3 == 0
	div5 := number % 5 == 0
	div7 := number % 7 == 0
	
	if !div3 && !div5 && !div7 {
		return fmt.tprint(number)
	}
	
	builder := strings.builder_make(0, 16)
	defer strings.builder_destroy(&builder)
	
	if div3 do strings.write_string(&builder, "Pling")
	if div5 do strings.write_string(&builder, "Plang")
	if div7 do strings.write_string(&builder, "Plong")
	
	return strings.clone(strings.to_string(builder))
}
    