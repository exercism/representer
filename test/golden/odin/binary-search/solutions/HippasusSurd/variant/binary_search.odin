package binary_search

import "core:fmt"
import "core:slice"

find :: proc(haystack: []$T, needle: T) -> (index: int, found: bool) #optional_ok {
	
	n := len(haystack)

	if (n == 0) do return 0, false

	left, right := 0, n - 1

	for left != right {
		mid := (left + right) >> 1
		if haystack[mid] >= needle {
			right = mid
		} else {
			left = mid + 1
		}													
	}

	return left, haystack[left] != needle
}
