module main

struct CircularBuffer[T] {
	capacity usize
mut:
	buffer []T
	front  usize
	size   usize
}

// For some reason, Exercism wants capacity to be int
// rather than usize.
pub fn create_buffer[T](capacity int) CircularBuffer[T] {
	if capacity < 0 {
		panic('Capacity must be >= 0')
	}
    return CircularBuffer[T]{
		capacity: usize(capacity)
		buffer: []T{len: capacity}
		front: 0
		size: 0
	}
}

pub fn (mut b CircularBuffer[T]) write(value T) ! {
	if b.size == b.capacity {
		return error('Buffer is full')
	}
	index := (b.front + b.size) % b.capacity
	b.buffer[index] = value
	b.size++
}

pub fn (mut b CircularBuffer[T]) read() !T {
	if b.size == 0 {
		return error('Buffer is empty')
	}
	value := b.buffer[b.front]
	b.front = (b.front + 1) % b.capacity
	b.size--
	return value
}

pub fn (mut b CircularBuffer[T]) overwrite(value T) {
	if b.size == b.capacity {
		b.buffer[b.front] = value
		b.front = (b.front + 1) % b.capacity
	} else {
		b.write(value) or {} // Should never fail.
	}
}

pub fn (mut b CircularBuffer[T]) clear() {
	b.front = 0
	b.size = 0
}
