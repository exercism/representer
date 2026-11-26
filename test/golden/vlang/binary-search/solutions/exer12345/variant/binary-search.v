module main

pub fn find(array []int, value int) !int {
	mut low := 0
	mut high := array.len - 1

	for low <= high {
		mid := (low + high) / 2
		if array[mid] == value {
			return mid
		} else if array[mid] <= value {
			low = mid + 1
		} else {
			high = mid - 1
		}
	}

	return error('value not in array')
}
