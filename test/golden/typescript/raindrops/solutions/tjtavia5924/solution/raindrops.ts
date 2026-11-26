export function convert(number: number): string {

  let three = "Pling"
  let five = "Plang"
  let seven = 'Plong'

let output = ''
   if (number % 3 === 0) output += three
   if ( number % 5 === 0) output += five
  if(number % 7 === 0) output += seven
  return output ? output : number.toString()
}

convert(15)