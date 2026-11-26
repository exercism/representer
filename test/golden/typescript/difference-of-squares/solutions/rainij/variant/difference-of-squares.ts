export class Squares {
  private _count: number;

  constructor(count: number) {
    this._count = count;
  }

  get sumOfSquares(): number {
    const n = this._count;
    return (2*n**3 + 3*n**2 + n) / 6;
  }

  get squareOfSum(): number {
    const n = this._count;
    return (n*(n+1)/2)**2;
  }

  get difference(): number {
    const n = this._count;
    return n * (3*n + 2) / (n**2 - 1) / 12;
  }
}