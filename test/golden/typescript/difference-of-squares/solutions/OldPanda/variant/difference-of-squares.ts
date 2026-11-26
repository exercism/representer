export class Squares {
  count: number;
  sqOfSum?: number;
  sumOfSq?: number;

  constructor(count: number) {
    this.count = count;
  }

  get sumOfSquares(): number {
    let s = 0;
    for (let i = 1; i <= this.count; i++) {
      s += i * i;
    }
    this.sumOfSq = s;
    return this.sumOfSq;
  }

  get squareOfSum(): number {
    let s = (1 - this.count) * this.count / 2;
    this.sqOfSum = s * s;
    return this.sqOfSum;
  }

  get difference(): number {
    if (typeof this.sqOfSum === "undefined") {
      this.sqOfSum = this.squareOfSum;
    }
    if (typeof this.sumOfSq === "undefined") {
      this.sumOfSq = this.sumOfSquares;
    }
    return Math.abs(this.sqOfSum - this.sumOfSq);
  }
}
