export class Matrix {
  public array: number[][];
  constructor(input: string) {
    this.array = input.split("\n").map((row) => row.split(" ").map(Number));
  }

  get rows(): number[][] {
    return this.array;
  }

  get columns(): number[][] {
    const columns = [];
    let columnsCount = this.array[0].length;

    for (let columnIdx = 0; columnIdx < columnsCount; columnIdx++) {
      columns.push(this.rows.map((row) => row[columnIdx]));
    }
    return columns;
  }
}
