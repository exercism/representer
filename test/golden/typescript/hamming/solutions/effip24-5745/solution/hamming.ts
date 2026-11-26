export function compute(left: string, right: string): number {
  let counter: number = 0

  left.split("").forEach((char, index) => {
    if(char !== right.split("")[index])counter++
  })

  if(left.length !== right.length)throw new Error("DNA strands must be of equal length.")

  return counter
}
