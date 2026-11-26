class CircularBuffer:
	var _buf := []
	var _next_write := 0
	var _next_read := 0


	func _init(capacity):
		for i in capacity:
			_buf.append(null)


	func write(value):
		if _buf[_next_write] != null:
			return false
		_buf[_next_write] = value
		_next_write = (_next_write + 1) % len(_buf)
		return true


	func read():
		var value = _buf[_next_read]
		_buf[_next_read] = null
		if value == null:
			return null
		_next_read = (_next_read + 1) % len(_buf)
		return value


	func overwrite(value):
		var old = _buf[_next_write]
		_buf[_next_write] = value
		if _next_write == _next_read:
			_next_read = (_next_read + 1) % len(_buf)
		_next_write = (_next_write + 1) % len(_buf)
		return old


	func clear():
		for i in len(_buf):
			_buf[i] = null
		_next_write = 0
		_next_read = 0
