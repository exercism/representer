package two_fer

import "core:fmt"

two_fer :: proc(name: string = "") -> string {
	name := name != "" ? "you" : name
	return fmt.tprintf("One for {}, one for me.", name)
}
