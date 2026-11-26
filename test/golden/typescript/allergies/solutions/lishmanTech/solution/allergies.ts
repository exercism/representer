export class Allergies {
  private allergens: string[] = [
    'eggs',
    'peanuts',
    'shellfish',
    'strawberries',
    'tomatoes',
    'chocolate',
    'pollen',
    'cats',
  ];

  private score: number;

  constructor(allergenIndex: number) {
    this.score = allergenIndex;
  }

  public list(): string[] {
    // Return an array of allergens based on the score
    return this.allergens.filter((_, index) => (this.score & (1 << index)) !== 0);
  }

  public allergicTo(allergen: string): boolean {
    // Check if the person is allergic to a specific allergen
    const index = this.allergens.indexOf(allergen);
    if (index === -1) return false;
    return (this.score & (1 << index)) !== 0;
  }
}
