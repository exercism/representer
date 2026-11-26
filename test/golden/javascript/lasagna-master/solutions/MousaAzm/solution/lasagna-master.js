/// <reference path="./global.d.ts" />
// @ts-check

/**
 * Implement the functions needed to solve the exercise here.
 * Do not forget to export them so they are available for the
 * tests. Here an example of the syntax as reminder:
 *
 * export function yourFunction(...) {
 *   ...
 * }
 */

export function cookingStatus(input) {
  if(input == 0) {
     return 'Lasagna is done.';
  } else if(!input){
     return 'You forgot to set the timer.';
  } else {
     return 'Not done, please wait.';
  }
}

export function preparationTime(layers, time) {
  let total;
  for(total = 0; total < layers.length; total++){
     total;
  }
  return time? total * time : total * 2;
}

export function quantities(layers) {
  const result = {noodles: 0, sauce : 0};
  let noodles = 0;
  let sauce = 0;
  for (let index of layers){
    if(index == 'noodles'){
         noodles += 50;
    }
    if(index == 'sauce'){
         sauce += 0.2;
    } 
  }
  result['noodles'] = noodles;
  result['sauce'] = sauce;
  return result;
}

export function addSecretIngredient(friendsList, myList) {
  myList.push(friendsList.at(-1));
}

export function scaleRecipe(recipe, numPortion = 2) {
  const myRecipe  = {...recipe};
  for (let item in myRecipe) {
    myRecipe[item] *= (numPortion / 2)
  }
  return myRecipe;
}



