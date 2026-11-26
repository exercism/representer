func score(x, y):
	var Circles: Dictionary = {
		"inner_limit": 1,
		"middle_limit": 5,
		"outer_limit": 10
	}
	var VectorOfHitZone: Vector2 = Vector2(x, y)
	var AbsoluteVector: Vector2 = VectorOfHitZone.abs()
	var Distance: float = AbsoluteVector.length()
	if Distance < Circles["inner_limit"]:
		return 10
	elif Distance <= Circles["middle_limit"]:
		return 5
	elif Distance <= Circles["outer_limit"]:
		return 1
	else: 
		return 0	