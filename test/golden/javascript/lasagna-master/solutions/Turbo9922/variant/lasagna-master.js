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
export function cookingStatus(minutes) {
  if (minutes === undefined) {
    return 'You forgot to set the timer.';
  } else if (minutes === 0) {
    return 'Lasagna is done.';
  } else {
    return 'Not done, please wait.';
  }
}

export function preparationTime(layers, timePerLayer = 2) {
  return layers.length * timePerLayer;
}
export function quantities(layers) {
  // Initialize quantities
  let quantities = {
    noodles: 0,
    sauce: 0
  };

  // Iterate through layers and add quantities for noodles and sauce
  layers.forEach(layer => {
    if (layer === 'noodles') {
      quantities.noodles += 50; // Each noodle layer adds 50 grams
    } else if (layer === 'sauce') {
      quantities.sauce += 0.2; // Each sauce layer adds 0.2 liters
    }
  });

  return quantities;
}

export function addSecretIngredient(friendsList, myList) {
  const secretIngredient = friendsList[friendsList.length - 1]; // Get the last ingredient
  myList.push(secretIngredient); // Add it to myList
}


export function scaleRecipe(recipe, portions) {
  const scaledRecipe = {};
  const scaleFactor = portions / 2; // Assuming the original recipe is for 2 portions

  // Iterate through the recipe and multiply each quantity by the scale factor
  for (const ingredient in recipe) {
    if (recipe.hasOwnProperty(ingredient)) {
      // Scale the quantity and round to 6 decimal places
      scaledRecipe[ingredient] = Number((recipe[ingredient] / scaleFactor).toFixed(6));
    }
  }

  return scaledRecipe;
}