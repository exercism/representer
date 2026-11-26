import 'dart:io';

class Allergies {
  final Map<String, int> allergens = {
    'eggs': 1,
    'peanuts': 2,
    'shellfish': 4,
    'strawberries': 8,
    'tomatoes': 16,
    'chocolate': 32,
    'pollen': 64,
    'cats': 128,
  };

  bool allergicTo(String allergen, int score) {
    if (allergens.containsKey(allergen)) {
      return (score & allergens[allergen]!) != 0;
    }
    return false;
  }

  List<String> list(int score) {
    List<String> allergiesList = [];
    allergens.forEach((allergen, value) {
      if ((score & value) != 0) {
        allergiesList.add(allergen);
      }
    });
    return allergiesList;
  }
}

void main() {
  try {
    print('Nhập điểm số cho chất gây dị ứng:');
    int score = int.parse(stdin.readLineSync()!);

    Allergies allergies = Allergies();

    print('Nhập tên chất gây dị ứng:');
    String allergen = stdin.readLineSync()!;

    bool isAllergic = allergies.allergicTo(allergen, score);
    print('Có dị ứng với $allergen: $isAllergic');

    List<String> allergyList = allergies.list(score);
    print('Các chất gây dị ứng có trong điểm số $score:');
    for (String allergen in allergyList) {
      print(allergen);
    }
  } catch (e) {
    print(e);
  }
}
