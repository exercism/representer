export const rows = (numRows) => {
  if (numRows === 0) return [];
  if (numRows === 1) return [[1]];
  let pascalsTriangle = [];
  for (let row = 1; row <= numRows; row++){
    let rowArray = [];
    for (let col = 0; col < row; col++){
      if (col === 0 || col === (row - 1)){
	rowArray.push(1);
      } else {
	rowArray.push((pascalsTriangle[row - 2][col - 1]
	  + pascalsTriangle[row - 2][col]));
      }
    }
    pascalsTriangle.push(rowArray);
  }
  return pascalsTriangle;
}
