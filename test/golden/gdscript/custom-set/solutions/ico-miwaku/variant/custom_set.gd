class Set:
	var _dict := {}


	func _init(elements):
		for element in elements:
			_dict[element] = element


	func empty():
		return _dict.size() != 0


	func contains(element):
		return element in _dict


	func subset(other):
		for v in _dict:
			if not other.contains(v):
				return false
		return true
		

	func disjoint(other):
		for v in other._dict:
			if contains(v):
				return false
		return true


	func equal(other):
		return _dict.recursive_equal(other._dict, 1)


	func add(element):
		_dict[element] = element
		return self


	func intersection(other):
		var dict := {}
		for v in other._dict:
			if contains(v):
				dict[v] = v
		_dict = dict
		return self


	func difference(other):
		for v in other._dict:
			if contains(v):
				_dict.erase(v)
		return self


	func union(other):
		for v in other._dict:
			add(v)
		return self
