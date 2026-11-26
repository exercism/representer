func spiral_matrix(size: int):
	var mat := make_matrix(size)
	var pos := Vector2i.ZERO
	var dir := Vector2i.RIGHT
	for i in size * size:
		mat[pos.y][pos.x] = i + 1
		var next := pos + dir
		if next.x < 0 or next.x >= size or next.y < 0 or next.y >= size or mat[next.y][next.x] != 0:
			dir = Vector2i(-dir.y, dir.x)
		pos += dir
	return mat


func make_matrix(size: int) -> Array:
	var matrix := []
	for i in range(size):
		var line := []
		for j in range(size):
			line.push_back(0)
		matrix.push_back(line)
	return matrix



