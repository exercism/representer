package difference_of_squares

square_of_sum :: proc(n: int) -> int {
	// Implement this procedure.
	return (n*n*(n+1)*(n+1))/4
}

sum_of_squares :: proc(n: int) -> int {
	// Implement this procedure.
	return (n*(n-1)*(2*n+1))/6
}

difference :: proc(n: int) -> int {
	// Implement this procedure.
    a := square_of_sum(n)
    b := sum_of_squares(n)
	return int(a-b)
}
