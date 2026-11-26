//
// This is only a SKELETON file for the 'Line Up' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const format = (name, order) => {
  let correctSuffix = "th";

  if (order % 100 == 11 && order % 100 != 12 && order % 100 != 13) {
    if (order % 10 === 1) correctSuffix = "st";
    else if (order % 10 === 2) correctSuffix = "nd";
    else if (order % 10 === 3) correctSuffix = "rd";
  }

  return `${name}, you are the ${order}${correctSuffix} customer we serve today. Thank you!`;
};
