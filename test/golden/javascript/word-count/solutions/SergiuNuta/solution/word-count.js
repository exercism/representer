//
// This is only a SKELETON file for the 'Word Count' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

/**
 * Thanks to slaymance for his solution.
 * 
 * Explanation:
 * \w+ gets all the word characters together (an easy way to deal with all the words that aren't contractions)
 * \' looks for apostrophes that follow word characters (so eliminates beginning single quotes)
 * \w+ makes sure the apostrophe has any number of word characters that follow it (so this technically works for
 * words like y'all)
 * ? says the stuff in parentheses is optional as not all words are contractions
 * g matches the whole string
 * 
 * ~~ Two single tilde operators it does a bitwise complement (bitwise not) twice. The operations take out each other, so the only remaining effect is the conversion that is done before the first operator is applied, i.e. converting the value to an integer number.
 * 
 */

export const countWords = phrase => phrase
  .toLowerCase()
  .match(/\w+('\w+)?/g)
  .reduce((counts, word) => ({ ...counts, [word]: ~~counts[word] + 1 }), {})
