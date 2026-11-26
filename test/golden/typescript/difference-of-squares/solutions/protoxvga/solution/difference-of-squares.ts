export class Squares {
    limit: number;
    firstResult: number;
    secondResult: number;

    constructor(count: number) {
        this.limit = count;
        this.firstResult = 0;
        this.secondResult = 0;
    }
  
    get squareOfSum(): number {
        let result = 0;

        for (let count = 0; count <= this.limit; count++)
            result += count;

        this.firstResult = Math.pow(result, 2);
        return (Math.pow(result, 2));
    }

    get sumOfSquares(): number {
       let result = 0;

        for (let count = 0; count <= this.limit; count++)
            result += Math.pow(count, 2);

        this.secondResult = result;
        return (result);
    }
  
    get difference(): number {
        return(this.firstResult - this.secondResult);
    }
}
