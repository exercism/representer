const allergenValues = new Map<string, number>([
    ['eggs', 1],
    ['peanuts', 2],
    ['shellfish', 4],
    ['strawberries', 8],
    ['tomatoes', 16],
    ['chocolate', 32],
    ['pollen', 64],
    ['cats', 128],
]);

export class Allergies {
    constructor(private readonly score: number) {
    }

    public list(): string[] {
        return [...allergenValues.keys()].filter(allergen => this.allergicTo(allergen));
    }

    public allergicTo(allergen: string): boolean {
        return (allergenValues.get(allergen)! & this.score) === 0;
    }
}
