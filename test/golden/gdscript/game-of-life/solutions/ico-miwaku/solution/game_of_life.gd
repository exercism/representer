func tick(matrix: Array):
	var result := matrix.duplicate(true)
	var height := matrix.size()
	if height == 0: return result
	var width = matrix[0].size()
	
	for y in height:
		for x in width:
			var neighbors := 0
			for dy in range(-1, 2):
				for dx in range(-1, 2):
					if (dy != 0 or dx != 0) and get_cell(matrix, y + dy, x + dx):
						neighbors += 1
			var target = get_cell(matrix, y, x)
						
			if target and (neighbors == 2 or neighbors == 3):
				pass
			elif not target and neighbors == 3:
				result[y][x] = 1
			else:
				result[y][x] = 0
				
	return result


func get_cell(matrix: Array, row: int, col: int):
	if row < 0 or row >= matrix.size() or col < 0 or col >= matrix[0].size():
		return null
	return matrix[row][col]
