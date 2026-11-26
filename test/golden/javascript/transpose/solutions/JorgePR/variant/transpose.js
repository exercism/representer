//
// This is only a SKELETON file for the 'Transpose' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const transpose = (matrix) => {
  if(matrix.length === 0) return [];
  let result = [];

      matrix.map((n,index) => {
        [...n].map((sym,i) => {
            if(!result[i]) result[i] = '';
        if(n.length >= 0){
          result[i] += ' '.repeat(index-result[i].length)+ sym;
        } else result[i] += n[i];
})
      })

  return result;
};
