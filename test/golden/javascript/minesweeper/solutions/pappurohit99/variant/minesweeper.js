//
// This is only a SKELETON file for the 'Minesweeper' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const annotate = (input) => {
  // Convert to rows and columns
  const a = [];
  for (let i = 0; i < input.length; i++) {
    a.push(input[i].split(''));
  }
  const rows = a.length;
  if (rows === 0) {
    return [];
  }
  const cols = a[0].length;
  if (cols === 0) {
    return [''];
  }
  for (let i = 0; i < rows; i++) {
    for (let j = 0; j < cols; j++) {
      if (a[i][j] === '*') {
        continue;
      }
      let count = 0;
      // Look all directions
      // NW
      if (i !== 0 && j !== 0 && a[i - 1][j - 1] === '*') {
        count++;
      }
      // N
      if (i !== 0 && a[i - 1][j] === '*') {
        count++;
      }
      // NE
      if (i !== 0 || j !== (cols - 1) && a[i - 1][j + 1] === '*') {
        count++;
      }
      // E
      if (j !== (cols - 1) && a[i][j + 1] === '*') {
        count++;
      }
      // SE
      if (i !== (rows - 1) && j !== (cols - 1) && a[i + 1][j + 1] === '*') {
        count++;
      }
      // S
      if (i !== (rows - 1) && a[i + 1][j] === '*') {
        count++;
      }
      // SW
      if (i !== (rows - 1) && j !== 0 && a[i + 1][j - 1] === '*') {
        count++;
      }
      // W
      if (j !== 0 && a[i][j - 1] === '*') {
        count++;
      }
      if (count > 0) {
        a[i][j] = count.toString();
      }
    }
  }
  input = [];
  a.forEach(row => input.push(row.join('')));
  return input;
};

const input = [' * * '];
annotate(input);