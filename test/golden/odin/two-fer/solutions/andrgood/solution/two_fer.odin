package two_fer

import "core:fmt"

two_fer :: proc(name: string = "") -> string {
	// Implement this procedure.
	if name == "" {
		return "One for you, one for me."
	} else {
		return fmt.aprintf("One for %v, one for me.", name)
	}
}