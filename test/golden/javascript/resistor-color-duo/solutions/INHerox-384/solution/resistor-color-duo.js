//
// This is only a SKELETON file for the 'Resistor Color Duo' exercise. It's been provided as a
// convenience to get you started writing code faster.
//
export const colorCode = (color) => {
  switch (color) {
    case 'black':
      return 0;
    case 'brown':
      return 1;
    case "red":
      return 2;
    case "orange":
      return 3;
    case "yellow":
      return 4;
    case "green":
      return 5;
    case "blue":
      return 6;
    case "violet":
      return 7;
    case "grey":
      return 8;
    case "white":
      return 9;
  }
};
export const decodedValue = (colors) => {
  const firstColor = colors[0];
  const secondColor = colors[1];
  const firstDigit = colorCode(firstColor);
  const secondDigit = colorCode(secondColor);
  const resistorValue = (firstDigit * 10) + secondDigit;

  return resistorValue;
};