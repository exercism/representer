export function isLeap(year:number) {
  // if(year%4==0){
  //   if(year%100==0){
  //     if(year%400==0){
  //       return true;
  //     }
  //     else{
  //       return false;
  //     }
  //   }
  // }
  if(year%400==0 ){
  return true;
  }else if(year%4==0 && year%100!==0){
    return true;
  }
  else{
    return false;
  }
}
 
let result=isLeap(1900);
console.log(result);
