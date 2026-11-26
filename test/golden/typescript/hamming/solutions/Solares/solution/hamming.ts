export function compute(left: string, right: string): string | number {
  let count = 0
  if(!left && !right || left === right) return 0
  if(left.length !== right.length) throw new Error("DNA strands must be of equal length.")
  for(var idx = 0; idx < left.length; idx++) {
    if(left[idx] !== right[idx]) count++
  }
  return count
}
