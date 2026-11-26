export function decodedValue(names: string[]): number {
  const map: { [index: string]: number } = {
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
  };
  return parseInt(
    names
      .slice(0, 2)
      .reduce((accumulator: string, currentValue: string): string => {
        return "" + accumulator + map[currentValue];
      }, "")
  );
}

