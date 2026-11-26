class CircularBuffer {
  construct new(capacity) {
    _capacity = capacity
    clear()
  }

  isFull { _count >= _capacity }
  isEmpty { _count == 0 }
  
  write(value) {
    if (isFull) Fiber.abort(BufferFullError)
    _buffer[_head] = value
    _head = (_head + 1 >= _capacity) ? 0 : _head + 1
    _count = _count + 1
  }

  read() {
    if (isEmpty) Fiber.abort(BufferEmptyError)
    var ret = _buffer[_tail]
    _count = _count - 1
    _tail = (_tail + 1 >= _capacity) ? 0 : _tail + 1
    return ret
  }

  forceWrite(value) {
    if (isFull) read()
    write(value)
  }

  clear() {
    _buffer = [null] * _capacity
    _count = 0
    _head = 0
    _tail = 0
  }
}

var BufferFullError = "Buffer full"

var BufferEmptyError = "Buffer empty"
