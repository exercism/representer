class EmptyBufferException() extends Exception {}

class FullBufferException() extends Exception {}

class CircularBuffer(var capacity: Int) {

  val items = new Array[Int](capacity)

  var count = 0
  var readIndex = 0
  var writeIndex = 0
  
  def write(value: Int) = {
    if (count >= items.length) {
      throw new FullBufferException()
    }
    count += 1
    items(writeIndex) = value
    writeIndex = (writeIndex + 1) % items.length
  }

  def read(): Int = {
    if (count <= 0) {
      throw new EmptyBufferException()
    }
    count -= 1
    val item = items(readIndex)
    readIndex = (readIndex + 1) % items.length
    item
  }

  def overwrite(value: Int) = {
    if (count < items.length) {
      write(value)
    }
    else {
      items(writeIndex) = value
      writeIndex = (writeIndex + 1) % items.length
      readIndex = (readIndex + 1) % items.length
    }
  }

  def clear() = {
    count = 0
    readIndex = 0
    writeIndex = 0
  }
}
