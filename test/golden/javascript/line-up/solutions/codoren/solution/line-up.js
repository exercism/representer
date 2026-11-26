//
// This is only a SKELETON file for the 'Line Up' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

// @ts-check
export function format(name, number) {
  let suffix = "th";

  const lastTwo = number % 100;
  const last = number % 10;

  if (lastTwo < 11 || lastTwo > 13) {
    if (last === 1) {
      suffix = "st";
    } else if (last === 2) {
      suffix = "nd";
    } else if (last === 3) {
      suffix = "rd";
    }
  }

  return`${name}, you are the ${number}${suffix} customer we serve today. Thank you!`;
};