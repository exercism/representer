// @ts-check
//
// The line above enables type checking for this file. Various IDEs interpret
// the @ts-check directive. It will give you helpful autocompletion when
// implementing this exercise.

/**
 * Determines how long it takes to prepare a certain juice.
 *
 * @param {string} name
 * @returns {number} time in minutes
 */
export function timeToMixJuice(name) {
  switch(name){
    case 'Pure Strawberry Joy':
      return 0.5;
    break;
    case 'Energizer' :
      return 1.5;
    break;
    case 'Green Garden' :
      return 1.5;
    break;
    case 'Tropical Island' :
      return 3;
    break;
    case 'All or Nothing' :
      return 5;
    default:
      return 2.5;
  }
  throw new Error('Please implement the timeToMixJuice function');
}

/**
 * Calculates the number of limes that need to be cut
 * to reach a certain supply.
 *
 * @param {number} wedgesNeeded
 * @param {string[]} limes
 * @returns {number} number of limes cut
 */
export function limesToCut(wedgesNeeded, limes) {
  let totalWedges = 0;
  let limesCut = 0;
  let i=0;
 
  while(totalWedges < wedgesNeeded && i < limes.length ){
     let Wedges = 0;
    
    switch(limes[i]){
      case "small":
          Wedges += 6;
      break;
      case "medium":
          Wedges += 8;
      break;
      case "large":
          Wedges += 10;
      break;
    }
     if(wedgesNeeded >= 0){
      Wedges += 0;
    }
    totalWedges += Wedges;
    limesCut++;
    i++;
   
  }
  return limesCut;
  throw new Error('Please implement the limesToCut function');
}

/**
 * Determines which juices still need to be prepared after the end of the shift.
 *
 * @param {number} timeLeft
 * @param {string[]} orders
 * @returns {string[]} remaining orders after the time is up
 */
export function remainingOrders(timeLeft, orders) {
  do{
    timeLeft = timeLeft - timeToMixJuice(orders[0]);
      orders.shift();
  }while(timeLeft > 0 && orders !== 0)
  return orders;
  throw new Error('Please implement the remainingOrders function');
}
