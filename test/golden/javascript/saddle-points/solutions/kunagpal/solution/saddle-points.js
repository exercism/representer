export function saddlePoints(matrix) {
  let result = [];

  for (let i = 0; i < matrix.length; ++i) {
    let max = Math.max(...matrix[i]),
      pos = matrix[i].reduce((result, elem, index) => {
        (elem === max) && result.push(index);
        return result;
      }, []);

    if (!pos.length) { continue; }

    for (let l of pos) {
      let j,
        min = Infinity;

      for (j = 0; j < matrix.length; ++j) {
        (matrix[j][l] < min) && (min = matrix[j][l]);        
      }

      (max === min) && result.push({ row: i + 1, column: l + 1 });
    }
  }

  return result;
}
