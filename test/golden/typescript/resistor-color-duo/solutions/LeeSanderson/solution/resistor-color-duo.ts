
const colourLookup = ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"]

export function decodedValue(colours : string[]): number {
  let resistance = 0;
  for (let i = 0; i < Math.min(colours.length, 2); i++) {
    const colour = colours[i];
    resistance = resistance * 10;
    resistance += colourLookup.indexOf(colour);
  }

  return resistance;
}

