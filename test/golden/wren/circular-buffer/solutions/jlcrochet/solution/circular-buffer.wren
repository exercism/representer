class CircularBuffer {
    construct new(capacity) {
        _head = 0
        _tail = 0
        _size = 0
        _capacity = capacity
        _buffer = List.filled(capacity, 0)
    }

    write(x) {
        if (_size == _capacity) {
            Fiber.abort(BufferFullError)
        }

        _buffer[_tail] = x

        _tail = (_tail + 1) % _capacity
        _size = _size + 1
    }

    read() {
        if (_size == 0) {
            Fiber.abort(BufferEmptyError)
        }

        var value = _buffer[_head]

        _head = (_head + 1) % _capacity
        _size = _size - 1

        return value
    }

    forceWrite(x) {
        _buffer[_tail] = x

        _tail = (_tail + 1) % _capacity

        if (_size == _capacity) {
            _head = (_head + 1) % _capacity
        } else {
            _size = _size + 1
        }
    }

    clear() {
        _head = _tail = _size = 0
    }
}

var BufferFullError = "error message here"

var BufferEmptyError = "another error message here"
