//
// This is only a SKELETON file for the 'Pangram' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const isPangram = (sentence) => {
  let regex = /[a-z]/g;
  const set = new Set(sentence.toLowerCase().match(regex));
  console.log(set);
  return set.size === 26;
};
