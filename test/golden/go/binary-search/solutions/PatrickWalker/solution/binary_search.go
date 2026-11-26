package binarysearch

//SearchInts performs a binary search on a slice of ints
//returns -1 if not found
func SearchInts(numbers []int, key int) int {
	start := 0
	end := len(numbers) - 1

	for start <= end {
		searchPoint := (start + end) / 2
		if numbers[searchPoint] == key {
			return searchPoint
		} else if numbers[searchPoint] < key {
			start = searchPoint + 1
		} else {
			end = searchPoint - 1
		}
	}

	return -1
}
