var _lhs: Array
var _rhs: Array
var _lhs_alphabets: Array
var _rhs_alphabets: Array

func solve(puzzle: String):
	_parse(puzzle)
	var digits := range(10)
	return _fix_rhs_assignment(_rhs_alphabets, digits, {})


func _parse(puzzle: String) -> void:
	var array := puzzle.split("==")
	_lhs = Array(array[0].split("+")) \
		.map(func (s: String): return s.strip_edges().split())
	_rhs = array[1].strip_edges().split()

	var set1 := {}
	for c in _rhs:
		if c not in set1:
			set1[c] = true
	_rhs_alphabets = set1.keys()

	var set2 := {}
	for list in _lhs:
		for c in list:
			if c not in set2 and c not in set1:
				set2[c] = true
	_lhs_alphabets = set2.keys()


func _fix_rhs_assignment(alphabets: Array, digits: Array, assign: Dictionary):
	if alphabets.size() == 0:
		var rhs_value = _array_to_number(_rhs, assign)
		# if rhs_value == 10652:
		# 	print(assign, "  ", digits, "  ", _lhs_alphabets)
		# 
		if rhs_value == null:
			return null
		return _find_lhs_assignment(_lhs_alphabets, digits, assign, rhs_value)
	
	var c :String = alphabets[0]
	var rest := alphabets.duplicate().slice(1)
	
	for d in digits:
		var new_assign := assign.duplicate()
		new_assign[c] = d
		var new_digits := digits.duplicate()
		new_digits.erase(d)
		var sub_assign = _fix_rhs_assignment(rest, new_digits, new_assign)
		if sub_assign != null:
			return sub_assign


func _array_to_number(array: Array, assign: Dictionary):
	if array[0] not in assign or assign[array[0]] == 0: return null
	var value := 0
	for c in array:
		if c not in assign: return null
		value = value * 10 + assign[c]
	return value


func _find_lhs_assignment(alphabets: Array, digits: Array, assign: Dictionary, rhs_value: int):
	if alphabets.size() == 0:
		if _is_valid_assignment(assign):
			return assign
		else:
			return null

	var c :String = alphabets[0]
	var rest := alphabets.duplicate().slice(1)
	
	for d in digits:
		var new_assign := assign.duplicate()
		new_assign[c] = d
		var new_digits := digits.duplicate()
		new_digits.erase(d)
		var sub_assign = _find_lhs_assignment(rest, new_digits, new_assign, rhs_value)
		if sub_assign != null:
			return sub_assign


func _is_valid_assignment(assign: Dictionary):
	var rhs = _array_to_number(_rhs, assign)
	if rhs == null: return false
	
	var sum := 0
	for lhs_part in _lhs:
		var part = _array_to_number(lhs_part, assign)
		if part == null: return false
		sum += part
	
	if sum != rhs: return false
	return true
