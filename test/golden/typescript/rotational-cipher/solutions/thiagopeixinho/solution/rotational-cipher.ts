export function rotate(s:string,n:number):string {

  let AB:string = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
  let ab:string = AB.toLowerCase()
  let a:string = ""

  for (let i = 0; i < s.length; i++) {
    if(AB.indexOf(s[i])>=0){a+=AB[(AB.indexOf(s[i])+n)%26]}
    else if(ab.indexOf(s[i])>=0){a+=ab[(ab.indexOf(s[i])+n)%26]}
    else{a+=s[i]}
  }
  return a
}
