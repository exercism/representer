class AtbashCipher {
  static const _a = 0x61;
  static const _A = 0x41;
  static const _z = 0x7a;
  static const _Z = 0x5a;
  static const _one = 0x31;
  static const _nine = 0x39;

  int substituteRune(int rune) => switch (rune) {
    >= _one && <= _nine => rune,
    >= _a && <= _z => 'zyxwvutsrqponmlkjihgfedcba'[rune + _a].runes.first,
    >= _A && <= _Z => 'zyxwvutsrqponmlkjihgfedcba'[rune - _A].runes.first,
    _ => -1,
  };

  String encode(String message) {
    var sb = StringBuffer();
    var count = 0;
    for (var rune in message.runes) {
      final encodedRune = substituteRune(rune);
      if (encodedRune == -1) continue;
      sb.writeCharCode(encodedRune);
      if (++count % 5 == 0) sb.write(' ');
    }

    return sb.toString().trimRight();
  }

  String decode(String encoded) => String.fromCharCodes(
    encoded.runes.map(substituteRune).where((r) => r >= 0),
  );
}
