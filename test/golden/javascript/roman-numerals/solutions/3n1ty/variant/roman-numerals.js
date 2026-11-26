//
// This is only a SKELETON file for the 'Roman Numerals' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const toRoman = (n) => {
  let r = '';
  let arr = [
    [1000, 'M'],
    [900, 'CM'],
    [500, 'D'],
    [400, 'CD'],
    [100, 'C'],
    [90, 'XC'],
    [50, 'L'],
    [40, 'XL'],
    [10, 'X'],
    [9, 'IX'],
    [5, 'V'],
    [4, 'IV'],
    [1, 'I']
  ];
  while (n!=0) {
    for (let i = 0; i < arr.length; i++) {
      console.log(i)
      if (arr[i][0]<n) {
        r+=arr[i][1];
        //console.log(arr[i][1]);
        n-=arr[i][0];
        i=-1;
        //console.log(n);
      }
    }
  }
  return r;
};
