func find_sequence(position: Vector2, angle: float, prisms: Array):
	var trail := []
	while true:
		var result = hit_test(position, angle, prisms)
		if result == null:
			break
		else:
			trail.push_back(result[0])
			position = result[1]
			angle += result[2]
	return trail


func hit_test(position: Vector2, angle: float, prisms: Array) -> Variant:
	var length := INF
	var result = null
	var ray := Vector2.from_angle(deg_to_rad(angle))
	for prism in prisms:
		var v : Vector2 = prism[1] - position
		var v_len := v.length()
		var diff := absf(ray.length() * v_len - ray.dot(v) )
		if v_len > 0.0001 && diff < 0.0001 and v_len < length:
			result = prism
			length = v_len
	return result
