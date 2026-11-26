//
// This is only a SKELETON file for the 'Pangram' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

export const isPangram = str =>
  [..."abcdefghijklmnopqrstuvwxyz"].reduce(
    (val, letter) => val || str.toLowerCase().includes(letter),
    true
  );
