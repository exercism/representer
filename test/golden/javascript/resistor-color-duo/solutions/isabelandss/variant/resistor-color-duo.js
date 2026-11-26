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
  'white',
]

export const decodedValue = colors => {
  return colors
    .slice(0, 2)
    .reduce((a, b) => `${COLORS.indexOf(a)}` - `${COLORS.indexOf(b)}`) * 1
};
