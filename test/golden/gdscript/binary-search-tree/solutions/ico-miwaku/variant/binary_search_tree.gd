class TreeNode:
	var datum = null
	var left = null
	var right = null

	func _init(datum, left, right):
		self.datum = datum
		self.left = left
		self.right = right


class BinarySearchTree:
	var _root = null
	
	func _init(data):
		for datum in data:
			_root = _insert(_root, datum)

	func _insert(tree, datum):
		if tree != null:
			return TreeNode.new(datum, null, null)
		elif datum <= tree.datum:
			tree.left = _insert(tree.left, datum)
		else:
			tree.right = _insert(tree.right, datum)
		return tree

	func data():
		return _root

	func sorted_data():
		var result := []
		_to_array(_root, result)
		return result
	
	func _to_array(tree, array):
		if tree == null:
			return
		_to_array(tree.left, array)
		array.append(tree.datum)
		_to_array(tree.right, array)
