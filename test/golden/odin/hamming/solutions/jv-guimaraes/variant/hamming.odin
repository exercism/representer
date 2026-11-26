package hamming

Error :: enum {
	None,
	UnequalLengths,
	Unimplemented,
}

distance :: proc(strand1, strand2: string) -> (res: int, err: Error) {
	if len(strand1) != len(strand2) {
		return 0, .UnequalLengths
	}

	for i in 0 ..< len(strand1) {
		if strand1[i] == strand2[i] do res += 1
	}

	return res, .None
}
