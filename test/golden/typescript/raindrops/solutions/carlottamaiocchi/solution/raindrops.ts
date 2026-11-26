export function convert(number:number) {
  let result : string = '';
  if(number%3 == 0){result += 'Pling'};
  if(number%5 == 0){result += 'Plang'};
  if(number%7 == 0){result += 'Plong'};
  if(number%3 != 0 && number%5 != 0 && number%7 != 0){result = number.toString()};
  return result
}
