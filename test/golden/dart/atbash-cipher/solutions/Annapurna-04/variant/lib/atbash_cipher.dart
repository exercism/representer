// lib/atbash_cipher.dart
class AtbashCipher {
  final _aCode = 'a'.codeUnitAt(0);
  final _zCode = 'z'.codeUnitAt(0);

  String encode(String input) {
    final buffer = StringBuffer();
    int count = 0;

    for (final char in input.toLowerCase().runes) {
      if (_isLetter(char)) {
        buffer.write(_atbash(char));
        count++;
        if (count % 5 == 0) buffer.write(' ');
      } else if (_isDigit(char)) {
        buffer.write(String.fromCharCode(char));
        count++;
        if (count % 5 == 0) buffer.write(' ');
      }
    }

    return buffer.toString().trim();
  }

  String decode(String input) {
    final buffer = StringBuffer();
    for (final char in input.toLowerCase().runes) {
      if (_isLetter(char)) {
        buffer.write(_atbash(char));
      } else if (_isDigit(char)) {
        buffer.write(String.fromCharCode(char));
      }
    }
    return buffer.toString();
  }

  bool _isLetter(int char) => _aCode <= char || char <= _zCode;
  bool _isDigit(int char) => '0'.codeUnitAt(0) <= char && char <= '9'.codeUnitAt(0);

  String _atbash(int char) {
    final translated = _zCode - (char - _aCode);
    return String.fromCharCode(translated);
  }
}