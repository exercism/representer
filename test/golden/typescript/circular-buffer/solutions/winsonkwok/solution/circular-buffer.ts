export default class CircularBuffer<T> {
  buffer: T[];
  current: number;
  
  constructor(initial: number) {
    this.buffer = new Array(initial);
    this.current = 0;
  }

  write(value: T): void {
    if (this.current == this.buffer.length) {
            throw new BufferFullError('Full');
    } else {
      this.buffer[this.current++] = value;
    }
  }

  read(): T {
    if (this.current == 0) {
            throw new BufferEmptyError('Empty');
    } else {
      let result: T = this.buffer[0];
      let newBuffer = Array(this.buffer.length);
      this.buffer.slice(1, this.buffer.length).map((val, index) => newBuffer[index] = val);
      this.current--;
      this.buffer = newBuffer;
      return result;
    }
  }

  forceWrite(value: T): void {
    if (this.current < this.buffer.length) {
        this.write(value);
      } else {
        let result: T = this.read();
        this.write(value);
      }
  }

  clear(): void {
    this.buffer = new Array(this.buffer.length);
    this.current = 0;
  }
}

export class BufferFullError extends Error {
  constructor(msg: string) {
      super(msg);
  }
}

export class BufferEmptyError extends Error {
  constructor(msg: string) {
      super(msg);
  }
}
