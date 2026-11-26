package series

Error :: enum {
	None,
	Invalid_Series_Length_Too_Large,
	Invalid_Series_Length_Zero,
	Invalid_Series_Length_Negative,
	Invalid_Sequence_Empty,
	Unimplemented,
}

series :: proc(sequence: string, series_len: int) -> ([]string, Error) {
	l := len(sequence)
    if l < series_len && l != 0 {
        return nil, .Invalid_Series_Length_Too_Large
    }
    if series_len == 0 {
        return nil, .Invalid_Series_Length_Zero
    }
    if series_len < 0 {
        return nil, .Invalid_Series_Length_Negative
    }
    if l == 0 {
        return nil, .Invalid_Sequence_Empty
    }
    res := make([dynamic]string)
    for i := 0; i < l - series_len + 1; i += 1 {
        append(&res, sequence[i : i + series_len])
    }
	return res[:], .None
}
