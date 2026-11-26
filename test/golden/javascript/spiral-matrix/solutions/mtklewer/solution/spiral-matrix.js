//
// This is only a SKELETON file for the 'Spiral Matrix' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const spiralMatrix = (n) => {
  const result = [];
  let next = 0;
  
  for (let i = 0; i < n; ++i) {
    // Column
    result.map(row => (row.unshift(next++), row));
    // Row
    result.push([...Array(i + 1)].map(_ => next++));    
    result.reverse();
    result.map(row => (row.reverse()));
  }
  // Reverse order
  return result.map(row => row.map(k => n * n - k));
};