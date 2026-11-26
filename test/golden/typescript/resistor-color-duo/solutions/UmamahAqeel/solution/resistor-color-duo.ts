export function decodedValue(colors:string[]) {
  const colorMap: any = {
    black: 0,
    brown: 1,
    red: 2,
    orange: 3,
    yellow: 4,
    green: 5,
    blue: 6,
    violet: 7,
    grey: 8,
    white: 9
  };
  if (!colors?.length || colors?.length < 2) {
    throw new Error("There's an issue in the input")
  }

  return Number(`${colorMap[colors[0]]}${colorMap[colors[1]]}`);
}
