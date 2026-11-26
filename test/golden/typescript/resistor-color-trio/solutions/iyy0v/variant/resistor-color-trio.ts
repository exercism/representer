export function decodedResistorValue(colors: string[]): string {
  const COLORS = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white'];
  let num = (COLORS.indexOf(colors[0])*10 + COLORS.indexOf(colors[1])) * 10 ** COLORS.indexOf(colors[2]);
  let code = '';

  if(num === 0) code = num - ' ohms'
  else if(num%1000000000 === 0) code = num/1000000000 + ' gigaohms'
  else if(num%1000000 === 0) code = num/1000000 + ' megaohms'
  else if(num%1000 === 0) code = num/1000 + ' kiloohms'
  else code = num + ' ohms'

  return code
}
