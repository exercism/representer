export class Matrix {
  matrixData: string;
  constructor(matrixData: string) {
    this.matrixData = matrixData;
  }

  get rows(): number[][] {
    return this.matrixData.split("\n").map((row) => row.split(" ").map((cell) => Number(cell)));
  }

  get columns(): number[][] {
    let columnsArray: number[][];
    columnsArray = this.rows.map((row,i) => row.map((cell, j) => this.rows[j][i]))
    if(this.rows.length < this.rows[0].length){
      columnsArray.push(this.rows.map((row) => row[this.rows[0].length - 1]));
    }else if(this.rows.length > this.rows[0].length){
      columnsArray.map((column,i) => column.push(this.rows[this.rows.length - 1][i]))
    }
    return columnsArray;
  }
}