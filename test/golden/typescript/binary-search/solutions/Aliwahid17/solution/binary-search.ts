export function find<T>(haystack: T[], needle: T): number | never {
  let low = 0;
  let high = haystack.length - 1;
  let mid = 0;
  while(low <= high){
    mid = Math.floor((low + high) / 2);
    if(haystack[mid] < needle){
      low = mid+1;
    }
    else if(haystack[mid] > needle){
      high = mid-1;
    }
    else{
      return mid;
    }
  }
  throw new Error("Value not in array");
}
