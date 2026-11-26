type BandColors =
  | "black"
  | "brown"
  | "red"
  | "orange"
  | "yellow"
  | "green"
  | "blue"
  | "violet"
  | "grey"
  | "white";

export function decodedResistorValue(resistorColors: BandColors[]): string {
  const bands: BandColors[] = [
    "black",
    "brown",
    "red",
    "orange",
    "yellow",
    "green",
    "blue",
    "violet",
    "grey",
    "white",
  ];

  const root = `${bands.indexOf(resistorColors[0])}${bands.indexOf(
    resistorColors[1]
  )}`;
  const zeros = bands.indexOf(resistorColors[2]);
  const bandValue = `${root}${"0".repeat(zeros)}`.replace(/^0/, "");
  const numBandValue = Number(bandValue);

  if (numBandValue < 999) {
    return `${bandValue} ohms`;
  }

  if (numBandValue > 999 && numBandValue <= 999999) {
    return `${bandValue.slice(0, -3)} kiloohms`;
  }

  if (numBandValue > 999999 && numBandValue <= 999999999) {
    return `${bandValue.slice(0, -6)} megaohms`;
  }

  if (numBandValue > 999999999) {
    return `${bandValue.slice(0, -9)} gigaohms`;
  }
  return `${bandValue} ohms`;
}
