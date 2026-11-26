export function getBaseValue(colors: string[]): number {
  return Number(`${getColorValue(colors[0])}${getColorValue(colors[1])}`);
}

function getColorValue(color: string): number {
  return COLORS.findIndex(c => c === color);
}

const COLORS = [
  'black',
  'brown',
  'red',
  'orange',
  'yellow',
  'green',
  'blue',
  'violet',
  'grey',
  'white'
]

const BILLION = Math.pow(10, 9);
const MILLION = Math.pow(10, 6);
const THOUSAND = Math.pow(10, 3);

export function decodedResistorValue(colors: string[]): string {
  let value = getBaseValue([colors[0], colors[1]]);
  const tens = getColorValue(colors[2]);
  value = value * Math.pow(10, tens);

  if (value >= BILLION) {
    return `${value / BILLION} gigaohms`;
  } else if (value >= MILLION) {
    return `${value / MILLION} megaohms`;
  } else if (value > THOUSAND) {
    return `${value / THOUSAND} kiloohms`;
  }

  return `${value} ohms`;
}