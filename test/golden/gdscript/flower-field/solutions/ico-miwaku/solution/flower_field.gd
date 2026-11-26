var _garden
var _width := 0
var _height := 0


func annotate(garden):
	_height = len(garden)
	_width = 0 if _height == 0 else len(garden[0])
	_garden = garden.duplicate()
	
	for y in _height:
		for x in _width:
			if _get_cell(x, y) == 0:
				var num := 0
				for dy in [-1, 0, 1]:
					for dx in [-1, 0, 1]:
						if dx != 0 or dy != 0:
							num += _get_cell(x + dx, y + dy)
				garden[y][x] = " " if num == 0 else str(num)
	
	return garden


func _get_cell(x: int, y: int) -> int:
	if x < 0 or x >= _width or y < 0 or y >= _height:
		return 0
	var ch = _garden[y][x]
	return 1 if ch == "*" else 0
