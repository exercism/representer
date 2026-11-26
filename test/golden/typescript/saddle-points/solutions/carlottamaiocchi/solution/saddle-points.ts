export function saddlePoints(matrix : number[][]) {
  let result : {[key: string]: number}[] = [];
  let newMatrix = createColumnArray(matrix);
  for(let i=0; i<matrix.length; i++){
    for(let j=0; j<matrix[i].length; j++){
      const is_greater = matrix[i].filter(el => matrix[i][j] >= el);
      const is_lower = newMatrix[j].filter(el => matrix[i][j] <= el);
      if(is_greater.length == matrix[i].length && is_lower.length == newMatrix[j].length){ 
        result.push({
        'column':j+1, 
        'row':i+1
        });
      }
    }
  }
  return result;
};
export function createColumnArray(matrix : number[][]) {
  let newMatrix : number[][] = [];
  for(let i=0; i<matrix[0].length; i++){
    newMatrix.push([]);
    for(let j=0; j<matrix.length; j++){
      newMatrix[i].push(matrix[j][i]);
    };
  };
  return newMatrix;
};

