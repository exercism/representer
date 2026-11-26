export const findAnagrams = (word, arr) => {
  return arr
    .filter(x => x.toLowerCase() !== word.toLowerCase())
    .filter(x =>
      x.toLowerCase().split("").sort().join("") === word.toLowerCase().split("").sort().join(""));
};
