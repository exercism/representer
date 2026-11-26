type Colors = {[key: string]: number}

const colors: Colors = {
  black: 0,
  brown: 1,
  red: 2,
  orange: 3,
  yellow: 4,
  green: 5,
  blue: 6,
  violet: 7,
  grey: 8,
  white: 9,
}

export function decodedValue([firstColor, secondColor]: string[]) {
  const firstValue = colors[firstColor]
  const secondValue = colors[secondColor]

  return Number(`${firstValue}${secondValue}`)
}
