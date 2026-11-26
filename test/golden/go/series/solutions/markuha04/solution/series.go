package series

func All(n int, s string) []string {
	if n > len(s) || n <= 0 {
		return []string{}
	}
    var result []string
    maxStart := len(s) - n
    for i := 0; i <= maxStart; i++ {
		substring := s[i : i+n]
		result = append(result, substring)
	}
	return result
}

func UnsafeFirst(n int, s string) string {
	if n <= 0 || n > len(s) {		
		if n > len(s) || n <= 0 {
			return "" 
		}
	}
	return s[0:n]
}
