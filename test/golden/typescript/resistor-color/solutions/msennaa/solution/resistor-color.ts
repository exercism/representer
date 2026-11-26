export const colorCode = (colorName?:string) => {
  if (colorName) {
    return COLORS.indexOf(colorName);
  }
  return COLORS;
}

export const COLORS = ['black', 'brown', 'red', 'orange', 'yellow', 'green', 'blue', 'violet', 'grey', 'white'];
