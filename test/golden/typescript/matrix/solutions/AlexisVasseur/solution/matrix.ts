export class Matrix {
  rows: number[][];
  constructor(stringMatrix: string) {
    this.rows = [];
    const stringRows = stringMatrix.split('\n');
    if (stringRows === undefined) throw new Error('Invalid format');

    let matrixRowLengh: number;
    this.rows = stringRows.map((stringRow, indexRow) => {
      const stringRowValues = stringRow.split(' ');
      if (stringRowValues === undefined) throw new Error('Invalid row format');
      if (indexRow === 0) {
        matrixRowLengh = stringRowValues.length;
      } else {
        if (matrixRowLengh !== stringRowValues.length)
          throw new Error('Invalid row format');
      }
      return stringRowValues.map((value) => {
        const convertedValue = parseInt(value);
        if (isNaN(convertedValue))
          throw new Error('Extracted value is not a number');
        return convertedValue;
      });
    });
  }

  // Processing column from rows to avoid storing duplicate data
  get columns(): number[][] {
    let localColumns: number[][] = [];

    for (let rowIndex = 0; rowIndex < this.rows.length; rowIndex++) {
      localColumns.push(this.rows.map((row) => row[rowIndex]));
    }
    return localColumns;
  }
}
