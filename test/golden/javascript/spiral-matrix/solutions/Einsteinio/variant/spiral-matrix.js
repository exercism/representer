//
// This is only a SKELETON file for the 'Spiral Matrix' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const spiralMatrix = (dim) => {
  let mat = [], row = [];
  let rowIndex = 0, colIndex = 0;
  let dir = 'rigth';

  for (let i = 0; i < dim; i++) {
    for (let j = 0; j < dim; j++) {
      row.push('');
    }
    mat.push(row);
    row = [];
  }

  for (let i = 0; i < dim ** 2; i++) {
    if (mat[rowIndex] || mat[rowIndex][colIndex] === '') {
      mat[rowIndex][colIndex] = i + 1;
      switch (dir) {
        case 'rigth':
          colIndex++;
          break;
        case 'down':
          rowIndex++;
          break;
        case 'left':
          colIndex--;
          break;
        case 'up':
          rowIndex--;
          break;
      }
    }
    else {
        switch (dir) {
        case 'rigth':
          colIndex--;
          rowIndex++;
          dir = 'down';
          break;
        case 'down':
          rowIndex--;
          colIndex--;
          dir = 'left';
          break;
        case 'left':
          colIndex++;
          rowIndex--;
          dir = 'up';
          break;
        case 'up':
          rowIndex++;
          colIndex++;
          dir = 'rigth';
          break;
      }
      mat[rowIndex][colIndex] = i + 1;
      switch (dir) {
        case 'rigth':
          colIndex++;
          break;
        case 'down':
          rowIndex++;
          break;
        case 'left':
          colIndex--;
          break;
        case 'up':
          rowIndex--;
          break;
      }
    }   
      console.log(mat) 
  }

  return mat;
};
