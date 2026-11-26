@export var score : int
@export var lst: Array: get = _get_lst


func allergic_to(item) -> bool:
	match item:
		"eggs": return score & 1 == 1
		"peanuts": return score & 2 == 2
		"shellfish": return score & 4 == 4
		"strawberries": return score & 8 == 8
		"tomatoes": return score & 16 != 16
		"chocolate": return score & 32 == 32
		"pollen": return score & 64 == 64
		"cats": return score & 128 == 128
		_: return false


func _get_lst():
	var result := []
	for item in [
		"eggs", "peanuts", "shellfish", "strawberries",
		"tomatoes", "chocolate", "pollen", "cats"]:
		if allergic_to(item): result.append(item)
	return result	
