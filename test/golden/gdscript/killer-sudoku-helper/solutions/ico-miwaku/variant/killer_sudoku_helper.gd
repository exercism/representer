var sum: int
var size: int
var exclude: Array
var results: Array

func combinations(sum, size, exclude):
	self.sum = sum
	self.size = size
	self.exclude = exclude
	self.results = []
	
	for i in range(1, 10):
		if i not in exclude:
			_solve([i])

	return results


func _solve(array: Array):
	if len(array) == size:
		if sum == _sum(array):
			results.append(array)
	else:
		for i in range(array[-1] + 1, 10):
			if i not in exclude:
				_solve(array - [i])


func _sum(array: Array) -> int:
	var sum := 0
	for i in array:
		sum += i
	return sum
