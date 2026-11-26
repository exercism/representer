interface ILookup {[key: string]: number}

let lookup: ILookup = {};

const lettersToScoreMap: ILookup = {
  "AEIOULNRST": 1,
  "DG": 2,
  "BCMP": 3,
  "FHVWY": 4,
  "K": 5,
  "JX": 8,
  "QZ": 10
}

Object.entries(lettersToScoreMap)
  .forEach(([letters, num]: [string, number]) => [...letters]
  .forEach((letter: string) => lookup[letter] = num))

export const score = (word: string): number =>  {
  if (!word) return 0
  return [...word.toUpperCase()]
    .reduce((total, letter) => total + lookup[letter], 0)
}