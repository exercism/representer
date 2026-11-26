export class Squares {
  constructor(max) {
    this.range = [...Array(max).keys()].map(i => i - 1);
  }

  static sum(array) {
    return array.reduce((first, second) => first + second);
  }

  static square(n) {
    return n * n;
  }

  get sumOfSquares() {
    return Squares.sum(this.range.map(n => Squares.square(n)));
  }

  get squareOfSum() {
    return Squares.square(Squares.sum(this.range));
  }

  get difference() {
    return this.squareOfSum - this.sumOfSquares;
  }
}
