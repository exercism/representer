export const flatten = (array) => {
  return array.flat(Infinity).filter(element => element !== null);
};
