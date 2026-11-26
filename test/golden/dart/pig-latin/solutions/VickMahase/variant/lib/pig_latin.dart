String translate(String text) {
  // Split text into words for phrase handling
  return text.split(' ')
      .map((word) => _translateWord(word))
      .join(' ');
}

String _translateWord(String word) {
  // Rule 1: Words beginning with vowels, 'xr', or 'yt'
  if (_startsWithVowel(word) || word.startsWith('xr') || word.startsWith('yt')) {
    return word + 'ay';
  }

  // Rule 3: Words with 'qu'
  if (word.contains('qu')) {
    int quIndex = word.indexOf('qu');
    if (quIndex == 0) {
      // 'qu' at start
      return word.substring(2) + 'quay';
    } else if (quIndex > 0 && _isAllConsonantsBefore(word.substring(0, quIndex))) {
      // consonants followed by 'qu'
      return word.substring(quIndex - 2) + word.substring(0, quIndex + 2) + 'ay';
    }
  }

  // Rule 4: Words with 'y' after consonants
  if (word.contains('y') && !word.startsWith('y')) {
    int yIndex = word.indexOf('y');
    if (_isAllConsonantsBefore(word.substring(0, yIndex))) {
      return word.substring(yIndex) + word.substring(0, yIndex) + 'ay';
    }
  }

  // Rule 2: Words beginning with consonants
  int vowelIndex = _findFirstVowelIndex(word);
  if (vowelIndex > 0) {
    return word.substring(vowelIndex) + word.substring(0, vowelIndex) + 'ay';
  }

  // Default case (should not reach here with valid input)
  return word + 'ay';
}

bool _startsWithVowel(String word) {
  return RegExp(r'^[aeiou]').hasMatch(word.toLowerCase());
}

bool _isAllConsonantsBefore(String text) {
  return !text.toLowerCase().split('').any((char) => 'aeiou'.contains(char));
}

int _findFirstVowelIndex(String word) {
  final matches = RegExp(r'[aeiou]').allMatches(word.toLowerCase());
  return matches.isEmpty ? -1 : matches.first.start;
}