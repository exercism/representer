package accumulate

func Accumulate(input []string, operation func(string) string) []string {
	result := make([]string, len(input))

	for i, in := range input {
		result[i] = operation(in)
	}

	return result
}