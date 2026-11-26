/**
 * Parse input to create an acronym from it.
 * Only consider letters and single quote to form
 * words. Acronyms are then first letters of words.
 * 
 * @param {string} input 
 */
export const parse = (input) => 
  input
    .toUpperCase()
    .match(/[A-Z']+/g)
    .map(word => word[0])
    .join('');
