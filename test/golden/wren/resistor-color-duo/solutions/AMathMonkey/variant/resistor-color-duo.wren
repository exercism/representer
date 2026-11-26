var MAPPINGS = {
  "black": "0",
  "brown": "1",
  "red": "2",
  "orange": "3",
  "yellow": "4",
  "green": "5",
  "blue": "6",
  "violet": "7",
  "grey": "8",
  "white": "9",
}

class ResistorDuo {
  static decodedValue(colors) { Num.fromString(colors.take(3).map{|c| MAPPINGS[c] }.join()) }
}

