export function proverb(...input:string[]):string {
  let result = ''
  for(let i=0; i<input.length-1; i++){
    result += `For want of a ${input[i]} the ${input[i+1]} was lost.\n`
  }
    result += `And all for the want of a ${input[0]}.`
  return result
}
