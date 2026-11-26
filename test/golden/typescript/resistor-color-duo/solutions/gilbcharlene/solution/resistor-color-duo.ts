export function decodedValue(colors:string[]): number {
  if (colors.length < 2) {
    throw new Error('must have values to decode')
  }
  const [color1, color2, discardedColors] = colors
  return (COLORS.indexOf(color1)*10) + COLORS.indexOf(color2)
}

export const COLORS:string[] = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white']
