
export function flatten(arr: any[]) : number[]{
  return arr.flat(Infinity).filter(elem => elem !== undefined)
}
