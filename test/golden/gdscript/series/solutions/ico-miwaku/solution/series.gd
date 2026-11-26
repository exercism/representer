func slices(series: String, slice_length: int) -> Variant:
	if series.length() < slice_length or slice_length <= 0:
		return null
	
	var result := []
	for i in series.length() - slice_length + 1:
		result.append(series.substr(i, slice_length))

	return result
