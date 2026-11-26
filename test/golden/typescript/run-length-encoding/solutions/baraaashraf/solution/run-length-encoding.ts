export const encode = (str:string) => {
  let strarr = str.split("")
  let f = ''
  let rep = 1
  for(let i = 0 ; i < strarr.length ; i++){
    if(strarr[i] === strarr[i+1]){
      rep += 1
    } else {
      if(rep < 2){
        f += `${strarr[i]}`
        rep = 1
      }else{
        f += `${rep}${strarr[i]}`
        rep = 1
      }
      
    }
  }
  return f
};

export const decode = (str:string) => {
  let currentNum = "";
  let f = ''
  for (let char of str) {
    if(!isNaN(parseInt(char))){
      currentNum += char
    } else{
      if (currentNum) {
          f += char.repeat(Number(currentNum))
        console.log(f)
      }else{
        f += char
        console.log(f)
      }
        currentNum = ""

  }
}
  return f
}
