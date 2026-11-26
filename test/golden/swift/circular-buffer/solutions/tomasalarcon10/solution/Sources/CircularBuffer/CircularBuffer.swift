enum CircularBufferError: Error {
    case bufferEmpty
    case bufferFull
}

struct CircularBuffer {
    var buffer: [Int]
    let maxLength: Int
    var head: Int = 0
    var tail: Int = 0
    var curLength: Int = 0

    init(capacity: Int) {
        self.buffer = Array(repeating: 0, count: capacity)
        self.maxLength = capacity
    }

    mutating func write(_ num: Int) throws {
        if self.curLength < self.maxLength {
            if self.curLength == 0 {
                self.buffer[self.head] = num
            } else {
                self.tail = (self.tail+1) % self.maxLength
                self.buffer[self.tail] = num
            }
            self.curLength += 1
        } else {
            throw CircularBufferError.bufferFull
        }
    }

    mutating func read() throws -> Int {
        if self.curLength > 0 {
            let res = self.buffer[self.head]
            self.head = (self.head+1) % self.maxLength
            self.curLength -= 1
            return res
        } else {
            throw CircularBufferError.bufferEmpty
        }
    }

    mutating func overwrite(_ num: Int) {
        if self.curLength < self.maxLength {
            do {
                try self.write(num)
            } catch {}
        } else {
            self.head = (self.head+1) % self.maxLength
            self.tail = (self.tail+1) % self.maxLength
            self.buffer[self.tail] = num
        }
    }

    mutating func clear() {
        self.buffer = Array(repeating: 0, count: self.maxLength)
        self.head = 0
        self.tail = 0
        self.curLength = 0
    }
}