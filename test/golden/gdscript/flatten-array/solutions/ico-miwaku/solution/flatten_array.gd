func flatten(iterable) -> Array:
	var result := []
	for item in iterable:
		match typeof(item):
			TYPE_NIL:
				pass
			TYPE_ARRAY:
				result.append_array(flatten(item))
			_:
				result.append(item)
	return result
