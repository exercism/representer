export function cardTypeCheck(stack, cardType) {
  let count = 0
  stack.forEach( (card) => {
    if(card === cardType) {
      count ++
    } 
  })

  return count
}

/**
 * Determine how many cards are odd or even
 *
 * @param {number[]} stack
 * @param {boolean} type the type of value to check for - odd or even
 * @returns {number} number of cards that are either odd or even (depending on `type`)
 */
export function determineOddEvenCards(stack, type) {
  let even = 0
  let odd = 0
  for(const card of stack){
    if(card % 2 === 0){
      even++
    }
    else {
    odd++
      }
  }

  if(type == true){
    return even
  }
  return odd
}
