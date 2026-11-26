package flatten

// Flatten returns a single flattened list with all values except nil/null.
func Flatten(list interface{}) []interface{} {
	result := []interface{}{}
	switch item := list.(type) {
	case []interface{}:
		for _, val := range item {
			result = append(result, Flatten(val)...)
		}
	case interface{}:
		result = append(result, item)
	}
	return result
}