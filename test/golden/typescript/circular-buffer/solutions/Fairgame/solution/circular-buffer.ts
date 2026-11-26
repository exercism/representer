export class BufferFullError extends Error {
}

export class BufferEmptyError extends Error {
}

export default class CircularBuffer<T> {
    protected base: number;
    protected cap: number;
    protected data: Array<T>
    protected len: number;

    constructor(initial: number) {
        if (initial % 1 !== 0) {
            throw new Error("initial capacity must be an integer");
        }
        this.base = 0;
        this.cap = initial;
        this.data = new Array<T>(this.cap)
        this.len = 0;
    }

    write(value: T): void {
        if (this.len === this.cap) {
            throw new BufferFullError();
        }
        this.data[(this.base + this.len) % this.cap] = value;
        this.len++;
    }

    read(): T {
        if (this.len === 0) {
            throw new BufferEmptyError();
        }
        const value = this.data[this.base];
        this.base = (this.base + 1) % this.cap;
        this.len--;
        return value;
    }

    forceWrite(value: T): void {
        this.data[(this.base + this.len) % this.cap] = value;
        if (this.cap === this.len) {
            this.base = (this.base + 1) % this.cap;
            return;
        }
        this.len++;
    }

    clear(): void {
        this.base = 0;
        this.data = new Array<T>(this.cap)
        this.len = 0;
    }
}

