//
// This is only a SKELETON file for the 'Scrabble Score' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

const ONE_VALUE = ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T'];
const TWO_VALUE = ['D', 'G'];
const THREE_VALUE = ['B', 'C', 'M', 'P'];
const FOUR_VALUE = ['F', 'H', 'V', 'W', 'Y']
const FIVE_VALUE = 'K';
const EIGHT_VALUE = ['J', 'X'];
const TEN_VALUE = ['Q', 'Z'];
export const score = (word) => {
  const new_word = word.toUpperCase();
  let score = 0
  for (let i = 0; i < new_word.length; i++) {
    if (ONE_VALUE.includes(new_word[i])) {
      score += 1;
    }
    else if (TWO_VALUE.includes(new_word[i])) {
      score += 2;
    }
    else if (THREE_VALUE.includes(new_word[i])) {
      score += 3;
    }
    else if (FOUR_VALUE.includes(new_word[i])) {
      score += 4;
    }
    else if (new_word[i] === FIVE_VALUE) {
      score += 5;
    }
    else if (EIGHT_VALUE.includes(new_word[i])) {
      score += 8;
    }
    else if (TEN_VALUE.includes(new_word[i])) {
      score += 10;
    }
  }
  return score
};

console.log(score("cabbage"))