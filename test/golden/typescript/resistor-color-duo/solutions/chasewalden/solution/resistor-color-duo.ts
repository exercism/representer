export function decodedValue(values: string[]) {

  const lookup: Record<string, number> = {
    'black': 0,
    'brown': 1,
    'red': 2,
    'orange': 3,
    'yellow': 4,
    'green': 5,
    'blue': 6,
    'violet': 7,
    'grey': 8,
    'white': 9,
  }
  
  return values
    .slice(0,2)
    .reduce((acc, value) => {
      if (value in lookup)
        return acc * 10 + lookup[value];
  
      throw new Error(`unknown value "${value}`)
    }, 0)

}
