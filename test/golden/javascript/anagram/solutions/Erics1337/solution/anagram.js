// Approach: to find an anagram out of the options in the wordList,
//  if each char in the word appears in the wordList word in any order
// psuedocode: if word.toLowerCase split, sorted, and rejoined === word done the same,
//  filter wordList item to only include it

export const findAnagrams = (word, wordList) => {
  return wordList
  .filter( (w) => w.toLowerCase() !== word.toLowerCase() )
  .filter( (w) => w.toLowerCase().split('').sort().join('') ===
  word.toLowerCase().split('').sort().join('') );
};
