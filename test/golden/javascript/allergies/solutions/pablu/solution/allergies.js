
export class Allergies {
  static ALLERGENS = [
    'eggs',
    'peanuts',
    'shellfish',
    'strawberries',
    'tomatoes',
    'chocolate',
    'pollen',
    'cats'
  ]
  #allergens

  constructor(score = 0) {
    this.#allergens = Allergies.ALLERGENS.filter((_, i) => score >> i & 1);
  }
  list() {
    return this.#allergens;
  }
  allergicTo(allergen) {
    return this.#allergens.includes(allergen);
  }
}