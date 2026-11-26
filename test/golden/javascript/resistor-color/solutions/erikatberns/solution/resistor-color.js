//
// This is only a SKELETON file for the 'Resistor Color' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

const colorCode = colorValue => {
  return COLORS.indexOf(colorValue.toLowerCase());
};


const COLORS =
[
  "black",
  "brown",
  "red",
  "orange",
  "yellow",
  "green",
  "blue",
  "violet",
  "grey",
  "white"
];

export {colorCode, COLORS};

// colorCode("Black");
