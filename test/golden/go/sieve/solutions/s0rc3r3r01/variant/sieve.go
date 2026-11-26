package sieve

func Sieve(limit int) []int {
	list := make([]int, limit+1)
	var result []int
	for i := 0; i <= limit; i++ {
		list[i] = i
	}
	for i := 0; i < len(list); i++ {
		if list[i] == 0 || list[i] == 1 {
			continue
		}
		result = append(result, list[i])
		for i, j := 1, list[i]; j*i <= len(list); i++ {
			list[j*i] = 0
		}
	}

	return result
}
