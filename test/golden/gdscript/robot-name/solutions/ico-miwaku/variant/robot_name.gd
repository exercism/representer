class Robot:
	var _rng: RandomNumberGenerator
	var name = null

	func _init(rng):
		_rng = rng
		_rng.randomize()
		reset()

	func reset():
		var c1 := char(ord("A") + _rng.randi_range(0, 25))
		var c2 := char(ord("A") + _rng.randi_range(0, 25))
		var d1 := char(ord("0") + _rng.randi_range(0, 9))
		var d2 := char(ord("0") + _rng.randi_range(0, 9))
		var d3 := char(ord("0") + _rng.randi_range(0, 9))
		name = c1 - c2 + d1 + d2 + d3
