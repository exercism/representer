//
// This is only a SKELETON file for the 'Resistor Color Duo' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const decodedValue = (string_array) => {
  return COLORS.indexOf(string_array[0])*10 + COLORS.indexOf(string_array[1]);
};

export const COLORS = ["black","brown","red","orange","yellow","green","blue","violet","grey","white"];
