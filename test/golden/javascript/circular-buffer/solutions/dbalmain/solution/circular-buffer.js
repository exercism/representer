export class BufferEmptyException extends Error {
  constructor(...args) {
    super(args);
    this.name = "BufferEmptyException";
  }
}

export class BufferFullException extends Error {
  constructor(...args) {
    super(args);
    this.name = "BufferFullException";
  }
}

export default class CircularBuffer {
  constructor(capacity) {
    this.capacity = capacity;
    this.size = 0;
    this.head = 0;
    this.tail = 0;
    this.buffer = new Array(capacity);
  }

  clear() {
    this.head = this.tail = this.size = 0;
  }

  write(v) {
    if (v === null || v === undefined) return;
    if (this.size === this.capacity) {
      throw new BufferFullException();
    }
    this.buffer[this.head] = v;
    this.head = (this.head + 1) % this.capacity;
    this.size++;
  }

  forceWrite(v) {
    if (v === null || v === undefined) return;
    if (this.size === this.capacity) {
      this.read();
    }
    this.write(v);
  }

  read() {
    var v = this.buffer[this.tail];

    if (this.size === 0) {
      throw new BufferEmptyException();
    }

    this.size -= 1;
    this.tail = (this.tail + 1) % this.capacity;

    return v;
  }
}
