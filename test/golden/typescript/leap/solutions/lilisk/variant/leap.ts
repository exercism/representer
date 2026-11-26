export function isLeap(year : number):boolean {
  let kabisat:boolean;
  if (year % 100 ==0 && year % 400 !==0){
    kabisat = false;
  } else if (year % 400 != 0 || year % 4 == 0){
    kabisat = true;
  }else{
    kabisat = false;
  }
  return kabisat;
}
// export function isLeap(year: number): boolean {
//   if (year % 4 !== 0) { return false; }
//   if (year % 400 === 0) { return true; }
//   return year % 100 !== 0;
// }

// export function isLeap(num: number) {
//   if(num % 100 === 0 && num % 400 !== 0)
//     return false;
//   if((num % 400) === 0 || num % 4 === 0)
//     return true;
//   return false;
// }