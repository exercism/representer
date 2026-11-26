//
// This is only a SKELETON file for the 'Pascals Triangle' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const rows = (numRows) => {
  if (numRows === 0) return [];
  if (numRows === 1) return [[1]];
  let resultArray = [];
  for (let row = 1; row <= numRows; row++) {
    let arr = [];
    for (let col = 0; col < row; col++) {
      if (col === 0 || col === row - 1) {
        arr.push(1);
      } else {
        arr.push(resultArray[row - 2][col - 1] + resultArray[row - 2][col]);
      }
    }
    resultArray.push(arr);
  }
  return resultArray;
};
