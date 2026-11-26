@export var position: Vector2i
@export var direction: Vector2i


func move(instructions: String):
	for instruction in instructions:
		match instruction:
			"R":
				direction = Vector2i(direction.y, -direction.x)
			"L":
				direction = Vector2i(-direction.y, direction.x)
			"A":
				position += direction
