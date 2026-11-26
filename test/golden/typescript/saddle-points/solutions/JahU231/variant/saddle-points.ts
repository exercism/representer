export function saddlePoints(rows: number[][]): { row: number, column: number }[] {
  let candidates: { row: number, column: number }[] = [];
  let lowestInColumns: { [row: number]: number } = {};

  rows.forEach((row, rowIndex) => {
    let highestInRow = Math.max(...row);
    row.forEach((value, columnIndex) => {
      if (value <= highestInRow) {
        return;
      }

      if (!(columnIndex in lowestInColumns)) {
        let column: number[] = [];
        rows.forEach((value) => column.push(value[columnIndex]));
        lowestInColumns[columnIndex] = Math.min(...column);
      }

      if (lowestInColumns[columnIndex] === value) {
        candidates.push({ row: rowIndex + 1, column: columnIndex + 1});
      }
    })
  });

  return candidates;
}
