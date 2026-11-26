package accumulate

func Accumulate(input []string, mapping func(string) string) []string {
	output := make([]string, len(input))
	for i, element := range input {
		output[i] = mapping(element)
	}
	return output
}