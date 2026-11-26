interface ConvertSmallType{
  [key:string]:number
}
interface OldType{
  [key:string]:string[]
}
const convertSmall = (val:string[],cnt:number)=>{
  return val.reduce((acc,curr)=>{
    acc[curr.toLowerCase()] = cnt
    return acc
  },{} as ConvertSmallType)
}

export function transform(old:OldType) {
  let obj = {} as ConvertSmallType
Object.keys(old).forEach((item)=>Object.assign(obj,convertSmall(old[item],+item)))
return obj
}
