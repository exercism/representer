package strain

func Keep[V interface{}](collection []V, predicate func(V) bool) []V {
	result := []V{}
	for _, item := range collection {
		if predicate(item) {
			result = append(result, item)
		}
	}
	return result
}

func Discard[V interface{}](collection []V, predicate func(V) bool) []V {
	return Keep(collection, func(v V) bool { return !predicate(v) })
}
