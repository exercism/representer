//
// This is only a SKELETON file for the 'Flatten Array' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const flatten = (arr) => {
  const flat = [];
  for(let i in arr){
    if(arr[i] instanceof Array){
      const flatInner = flatten(arr[i]);
      for(let j in flatInner){
        flat.push(flatInner[j]);
      }
    }
    else if(arr[i] !== undefined && arr[i] !== null){
      flat.push(arr[i]);
    }
  }
  return flat;
};
