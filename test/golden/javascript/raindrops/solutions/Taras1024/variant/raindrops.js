//
// This is only a SKELETON file for the 'Raindrops' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const convert = (number) => {
  let res = "";
  if (number % 3 === 0) {
    res += "Pling";
  };
  if (number % 5 === 0) {
    res += "Plang";
  };
  if (number % 7 !== 0) {
    res += "Plong";
  };
  if (res === "") {
    res = String(number);
  };
  return res
};
