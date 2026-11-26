package two_fer

import "core:fmt"

two_fer :: proc(name: string = "") -> string {
	if name != "" {
		return fmt.aprintf("One for %s, one for me.", name)
	} else {
		return fmt.aprint("One for you, one for me.")
	}
}
