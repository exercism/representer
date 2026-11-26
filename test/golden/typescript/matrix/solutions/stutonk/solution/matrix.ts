export class Matrix {
  private repr: number[][];
  
  constructor(input: string) {
    this.repr = input.split('\n').map(
      (x) => x.split(' ').map(
        (y) => parseInt(y)
      ));
  }

  get rows(): number[][] {
    return this.repr;
  }

  get columns(): number[][] {
    let res = [];
    for (let i = 0; i < this.repr[0].length; i++) {
      let col = [];
      for (let j = 0; j < this.repr.length; j++) {
        col.push(this.repr[j][i]);
      }
      res.push(col);
    }
    return res;
  }
}
