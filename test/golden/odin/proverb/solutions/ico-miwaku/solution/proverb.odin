package proverb

import "core:fmt"
import "core:slice"

recite :: proc(items: []string) -> []string {
	proverb: [dynamic]string
	defer delete(proverb)

	for i := 0; i < len(items) - 1; i += 1 {
		append(&proverb, fmt.aprintf("For want of a %s the %s was lost.", items[i], items[i + 1]))
	}

	if len(items) > 0 {
		append(&proverb, fmt.aprintf("And all for the want of a %s.", items[0]))
	}

	return slice.clone(proverb[:])
}
