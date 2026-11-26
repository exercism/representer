//
// This is only a SKELETON file for the 'Pascals Triangle' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const rows = (inputRows) => {
  var pascalTriangle = [];
  for (let i = 0; i < inputRows; i++) {
    pascalTriangle.push([]);
    for (let j = 0; j < (i+1); j++) {
      if((i-1) < 0){
        pascalTriangle[i].push(1);
      }
      else{
        if(typeof(pascalTriangle[i-1][j]) == 'undefined' || 
          typeof(pascalTriangle[i-1][j-1]) == 'undefined'){
          pascalTriangle[i].push(1);
        }
        else{
        pascalTriangle[i].push(pascalTriangle[i-1][j] + pascalTriangle[i-1][j-1]);
        }
      }
    }
  }

  return pascalTriangle;
};