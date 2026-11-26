// @ts-check

/**
 * Calculates the sum of the two input arrays.
 *
 * @param {number[]} array1
 * @param {number[]} array2
 * @returns {number} sum of the two arrays
 */
export function twoSum(array1, array2) {
   const var1 = (parseInt(array1.join('')));
   const var2 = (parseInt(array2.join('')));
    return var1 + var2;
}

/**
 * Checks whether a number is a palindrome.
 *
 * @param {number} value
 * @returns {boolean} whether the number is a palindrome or not
 */
export function luckyNumber(value) {
  const rev = String(value)
 
 return rev.split('').reverse().join('') === rev;
}

/**
 * Determines the error message that should be shown to the user
 * for the given input value.
 *
 * @param {string|null|undefined} input
 * @returns {string} error message
 */
export function errorMessage(input) {

 switch (true) {
  case !input:
    return 'Required field';
  case isNaN(input) || input === "0" :
    return 'Must be a number besides 0';
  default:
    return '';
}

  
}
