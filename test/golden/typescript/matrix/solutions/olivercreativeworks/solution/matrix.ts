export class Matrix {
  matrix:Array<Array<number>>
  
  constructor(matrix:string) {
    this.matrix = Matrix.stringToMatrix(matrix)
  }

  private static stringToMatrix(matrix:string):Array<Array<number>>{
    return matrix.split("\n").map(arr => arr.split(" ").map(char => +char))
  }

  get rows(): Array<Array<number>> {
    return this.matrix
  }

  get columns(): Array<Array<number>> {
    const numOfColumns = this.matrix[0].length
    return Array.from({length:numOfColumns}, (_,colIndex) => this.matrix.map(row => row[colIndex]))
  }
}
