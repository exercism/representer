export function encode(s:string):string {

  let m:number=1
  let a:string=""

  while(s.length>0){
    m=1
    while (s[0]==s[1]){m++;s=s.slice(1)}
    if(m>1){a += m}
    a += s[0]
    s = s.slice(1)
  }
  return a
}

export function decode(s:string):string {

  let i:number=0
  let a:string=""
  let m:number=0

  while(s.length>0){
    i = 0
    while(Number(s[i])==Number(s[i])&&Number(s[i])!=0){i++}
    if (i==0){a+=s[i]}
    else{
      m = Number(s.slice(0,i))
      for (let j = 0; j < m; j++) {a+=s[i]}
    }
    s = s.slice(i+1)
  }
  return a
}
