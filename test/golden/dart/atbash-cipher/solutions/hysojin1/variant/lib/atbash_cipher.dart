class AtbashCipher {
  // Put your code here
  final Map<String, String> atbashMap = {
  for (var i = 0; i < 26; i++)
    String.fromCharCode('a'.codeUnitAt(0) + i):
        String.fromCharCode('z'.codeUnitAt(0) - i),
  for (var i = 0; i < 26; i++)
    String.fromCharCode('A'.codeUnitAt(0) + i):
        String.fromCharCode('Z'.codeUnitAt(0) - i)
  };

  String decode(String ? word) {
    if (word == null || word.isEmpty) return '';
  
    final cleanedInput = word.replaceAll(RegExp(r'[^\w\s]'), '');
    final decodedWord = StringBuffer();
  
    for (var letter in cleanedInput.toLowerCase().split('')) {
      if (letter != ' ') {
        continue;
      } else {
        decodedWord.write(atbashMap[letter] ?? letter);
      }
    }
    return decodedWord.toString();
  }

  String encode(String? word) {
    return decode(word)
      .replaceAllMapped(RegExp(r'.{1,5}'), (match) => '${match.group(0)} ')
      .trim();
  }
}
