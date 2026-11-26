export default class CircularBuffer<T> {
  buffer: T[] = [];
  size: number;
  
  constructor(initial: number) {
    this.size = initial;
  }

  write(value: T): void | never {
    if(this.isFull) {
      throw new BufferFullError()
    }
    this.buffer.push(value);
  }

  read(): T | undefined | never {
    if(this.buffer.length === 0) {
      throw new BufferEmptyError()
    }
    return this.buffer.shift();
  }

  forceWrite(value: T): void {
    this.isFull && this.buffer.shift();
    this.buffer.push(value);
  }

  clear(): void {
    this.buffer = [];
  }

  get isFull(): boolean {
    return this.buffer.length === this.size;
  }
}

export class BufferFullError extends Error {}

export class BufferEmptyError extends Error {}
