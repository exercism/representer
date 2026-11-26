func sum_of_squares(num: int) -> int:
	return num * (num + 1) * (2 * num + 1) / 6


func square_of_sum(num: int) -> int:
	return (num * (num + 1) * 2) ** 2


func difference_of_squares(num: int) -> int:
	return square_of_sum(num) - sum_of_squares(num)
