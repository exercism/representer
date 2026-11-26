import 'dart:math';

class ResistorColorTrio {
  static const Map<String, int> _colorValues = {
    'black': 0,
    'brown': 1,
    'red': 2,
    'orange': 3,
    'yellow': 4,
    'green': 5,
    'blue': 6,
    'violet': 7,
    'grey': 8,
    'white': 9,
  };

  String label(List<String> colors) {
    if (colors.length < 3) {
      throw ArgumentError('Three colors are required');
    }

    final first = _colorValues[colors[0]]!;
    final second = _colorValues[colors[1]]!;
    final multiplier = _colorValues[colors[2]]!;

    final ohms = (first * 10 + second) * pow(10, multiplier).toInt();

    if (ohms >= 1000000000) {
      return '${ohms ~/ 1000000000} gigaohms';
    } else if (ohms >= 1000000) {
      return '${ohms ~/ 1000000} megaohms';
    } else if (ohms >= 1000) {
      return '${ohms ~/ 1000} kiloohms';
    } else {
      return '$ohms ohms';
    }
  }
}