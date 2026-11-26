import 'dart:math';

class Allergies {
  final itemScoreList = [
    'eggs',
    'peanuts',
    'shellfish',
    'strawberries',
    'tomatoes',
    'chocolate',
    'pollen',
    'cats',
  ];

  /// Check if somebody is allergic to the item. The methods checks the bits
  bool allergicTo(String item, int score) {
    final index = itemScoreList.indexOf(item);
    final allergicBit = pow(2, index) as int;

    return (score & allergicBit) == allergicBit;
  }

  List<String> list(int score) =>
      itemScoreList.where((item) => allergicTo(item, score)).toList();
}
