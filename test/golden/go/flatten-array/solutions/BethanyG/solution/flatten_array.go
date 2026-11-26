//Package flatten takes a nested interface slice & unpacks it to a single level, returning an interface slice.

package flatten

//Flatten unpacks the interface, recursing until no enclosing interfaces are found.  Returns an interface slice.
func Flatten(input interface{}) []interface{} {
	result := []interface{}{}

	switch content := input.(type) {
	case []interface{}:
		for _, item := range content {
			result = append(result, Flatten(item)...)
		}
	case interface{}:
		result = append(result, content)
	}
	return result
}