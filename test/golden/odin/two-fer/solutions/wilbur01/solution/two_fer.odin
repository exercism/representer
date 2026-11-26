package two_fer
import "core:strings"

two_fer :: proc(name: string = "you") -> string {
	slices: [3]string = { "One for ", name, ", one for me." }
    return strings.concatenate(slices[:])
}
