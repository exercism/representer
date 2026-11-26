export function parse(phrase: string): string {
  let s:string = phrase.replace(/[.,\/!;:{}=\`~()]/g,"")
  let r:string = s.replace(/[#_$%&*-]/g," ")
  let t:string = r[0]
  for (let j = 1; j < r.length; j++) {
    if ( r[j]===r[j].toUpperCase()&&r[j-1]!=r[j-1].toUpperCase()){
      t += " " + r[j]
    }else{ t+= r[j]}
  } 
  t = t.replace(/\s{2,}/g," ")
  console.log(t)
  let a:string[] = t.split(" ")
  let ab: string = ""
  console.log(a)
  for (let i = 0; i < a.length; i++) {
    if ( a[i].length > 0){
    ab += (a[i])[0]
    }
  }
  return ab.toUpperCase()
}
