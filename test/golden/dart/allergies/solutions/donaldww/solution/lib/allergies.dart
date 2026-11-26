class Allergies {
  static const allergens = const {
    "eggs": 1,
    "peanuts": 2,
    "shellfish": 4,
    "strawberries": 8,
    "tomatoes": 16,
    "chocolate": 32,
    "pollen": 64,
    "cats": 128
  };

  bool allergicTo(String allergen, int value) =>
      allergens[allergen]! & value != 0;

  List<String> list(int value) =>
      allergens.keys.where((allergen) => allergicTo(allergen, value)).toList();
}
