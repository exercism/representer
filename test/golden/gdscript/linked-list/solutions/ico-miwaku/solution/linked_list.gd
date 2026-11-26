class LinkedList:
	var first = null
	var last = null
	
	func push(value):
		if first == null:
			first = { value = value, prev = null, next = null }
			last = first
			return
		
		var node := { value = value, prev = last, next = null }
		last.next = node
		last = node


	func unshift(value):
		if last == null:
			first = { value = value, prev = null, next = null }
			last = first
			return
					
		var node := { value = value, prev = null, next = first }
		first.prev = node
		first = node


	func delete(value):
		if first == null:
			return
		
		if first.value == value:
			first = first.next
			if first == null:
				last = null
				return
			first.prev = null
			return

		var prev = first
		var r = first.next
		while r != null and r.value != value:
			prev = r
			r = r.next
		
		if r == null:
			return
		
		if last == r:
			prev.next = null
			last = prev
			return

		prev.next = r.next
		if r.next == null:
			last = r
			return
		r.next.prev = prev


	func pop():
		if last == null:
			return null

		var v = last.value
		last = last.prev
		if last == null:
			first = null
		
		if last != null:
			last.next = null
		return v

		
	func shift():
		if first == null:
			return null
		
		var v = first.value
		first = first.next
		if first == null:
			last = null
		
		if first != null:
			first.prev = null
		return v


	func count():
		var c := 0
		var r = first
		while r != null:
			c += 1
			r = r.next
		return c
