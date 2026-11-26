package binary_search

find :: proc(haystack: []$T, needle: T) -> (index: int, found: bool) #optional_ok {
  if len(haystack) == 0 do return 0, false

  ub := len(haystack) // upper bound
  lb := 0             // lower bound

  for {
    index = (lb + ub) / 2

    switch {
    case haystack[index] > needle: ub = index
    case haystack[index] < needle: lb = index
    case:
      return index, true
    }

    if lb == ub - 1 do break
  }

	return 0, false
}
