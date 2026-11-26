class CircularBuffer {

  construct new(size) {
    _buffer = List.filled(size,null)
    _bufferSize = size - 1
    _writePointer = 0
    _readPointer = 0
  }

  write(toWrite) {
    if(_buffer[_writePointer] != null) {
      Fiber.abort(BufferFullError)
    }else {
        _buffer[_writePointer] = toWrite
        _writePointer = _writePointer + 1
        if(_writePointer > _bufferSize) {
          _writePointer = 0
        }
    }
  }

  read() {
    if(_buffer[_readPointer] == null) {
      Fiber.abort(BufferEmptyError)
    } else {
      var tmp = _buffer[_readPointer]
      _buffer[_readPointer] = null
      _readPointer = _readPointer + 1
      if(_readPointer > _bufferSize) {
          _readPointer = 0
      }
      return tmp
    }
  }

  forceWrite(toWrite) {
    if(_buffer[_writePointer] != null) {
      _buffer[_writePointer] = toWrite
      _writePointer = _writePointer + 1
      if(_writePointer > _bufferSize) {
        _writePointer = 0
      }
      _readPointer = _readPointer + 1
      if(_readPointer > _bufferSize) {
          _readPointer = 0
      }
    }else{
      write(toWrite)
    }
    
  }

  clear() {
    _buffer = List.filled(_bufferSize + 1,null)
    _writePointer = 0
    _readPointer = 0
  }
}

var BufferFullError = "error message here"

var BufferEmptyError = "another error message here"
