var COLORS = ["black", "brown", "red", "orange", "yellow", "green", "blue", "violet", "grey", "white"]

class ResistorDuo {
  static decodedValue(colors) {
    return colors
      .take(2)
      .map { |c| COLORS.indexOf(c) }
      .reduce { |acc, c| acc * 10 + c }
  }
}
