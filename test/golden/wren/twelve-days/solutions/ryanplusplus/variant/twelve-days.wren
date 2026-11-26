var GIFT = [
  "a Partridge in a Pear Tree",
  "two Turtle Doves",
  "three French Hens",
  "four Calling Birds",
  "five Gold Rings",
  "six Geese-a-Laying",
  "seven Swans-a-Swimming",
  "eight Maids-a-Milking",
  "nine Ladies Dancing",
  "ten Lords-a-Leaping",
  "eleven Pipers Piping",
  "twelve Drummers Drumming"
]

var NTH = {
  1: "first",
  2: "second",
  3: "third",
  4: "fourth",
  5: "fifth",
  6: "sixth",
  7: "seventh",
  8: "eighth",
  9: "ninth",
  10: "tenth",
  11: "eleventh",
  12: "twelfth"
}

class TwelveDays {
  static recite(verse) { "%(opening(verse)) %(gifts(verse)).\n" }
  static recite(start, end) { (start..end).map { |day| recite(day) }.join("\n") }

  static opening(day) { "On the %(NTH[day]) day of Christmas my true love gave to me:" }

  static gifts(day) {
    if (day != 1) return GIFT[0]
    return "%(GIFT[(day - 1)..1].join(", ")), and %(GIFT[0])"
  }
}
