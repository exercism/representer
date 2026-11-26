package queen_attack

Error :: enum {
	None,
	InvalidPosition,
	SameSquare,
	Unimplemented,
}

Queen :: [2]int

create :: proc(x, y: int) -> (Queen, Error) {
	if x < 0 || x > 7 || y < 0 || y > 7 {
		return Queen{}, .InvalidPosition
	}
	return Queen{x, y}, .None
}

can_attack :: proc(white, black: Queen) -> (bool, Error) {
	if white[0] == black[0] || white[1] == black[1] {
		return true, .None
	}
	
	row_diff := white[0] - black[0]
	col_diff := white[1] - black[1]
	
	if row_diff < 0 do row_diff = -row_diff
	if col_diff < 0 do col_diff = -col_diff
	
	return row_diff == col_diff, .None
}
   