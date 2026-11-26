class TwelveDays {
  final List<String> _days = [
    'first', 'second', 'third', 'fourth', 'fifth', 'sixth',
    'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth'
  ];

  final List<String> _gifts = [
    'a Partridge in a Pear Tree',
    'two Turtle Doves',
    'three French Hens',
    'four Calling Birds',
    'five Gold Rings',
    'six Geese-a-Laying',
    'seven Swans-a-Swimming',
    'eight Maids-a-Milking',
    'nine Ladies Dancing',
    'ten Lords-a-Leaping',
    'eleven Pipers Piping',
    'twelve Drummers Drumming'
  ];

  /// Returns a single String containing verses from [start] to [end]
  String recite(int start, int end) {
    List<String> verses = [];
    for (int i = start; i <= end; i++) {
      verses.add(_buildVerse(i));
    }
    // Join the verses with a newline character to return a single String
    return verses.join('\n');
  }

  String _buildVerse(int dayNumber) {
    int index = dayNumber - 1;
    String res = "On the ${_days[index]} day of Christmas my true love gave to me: ";
    
    for (int i = index; i >= 0; i--) {
      if (i == 0 && dayNumber > 1) {
        res += "and ${_gifts[i]}.";
      } else if (i == 0) {
        res += "${_gifts[i]}.";
      } else {
        res += "${_gifts[i]}, ";
      }
    }
    return res;
  }
}