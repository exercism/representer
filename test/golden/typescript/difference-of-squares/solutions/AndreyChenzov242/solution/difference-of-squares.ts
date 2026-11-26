export class Squares {
  private naturalNumbers: number[] = [];
  
  constructor(count: number) {
    for(let i = 1; i <= count; i++){
      this.naturalNumbers.push(i);
    }
  }

  get squareOfSum(): number {
    let sum = 0;
    for(let i = 0; i < this.naturalNumbers.length; i++){
      sum += this.naturalNumbers[i];
    }

    return sum ** 2;
  }

  get sumOfSquares(): number {
    let sum = 0;
    for(let i = 0; i < this.naturalNumbers.length; i++){
      sum += this.naturalNumbers[i] ** 2;
    }

    return sum;
  }

  get difference(): number {
    return this.squareOfSum - this.sumOfSquares;
  }
}
