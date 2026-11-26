class Diamond {

  final int CODE_A = 'A'.codeUnitAt(0);
  final int CODE_Z = 'Z'.codeUnitAt(0);
  final int CODE_SP = ' '.codeUnitAt(0);

  String _generateRow(int pad, int code, int size) {
      var row = new List<int>.filled(size, CODE_SP);

      row[pad] = code;
      row[size - 1 - pad] = code;

      return String.fromCharCodes(row);
  }

  List<String> rows(String letter) {
    
    int code = letter.codeUnitAt(0);

    if (letter.length != 1) return [];
    if (code < CODE_A || code > CODE_Z) return [];
    if (code == CODE_A) return ['A'];

    var iters = code - CODE_A;
    var size = iters * 2 + 1;

    List<String> rows = [letter + ' ' * (size - 2) + letter];

    for (var i = 0; i < iters; i++) {
      var row = _generateRow(i + 1, code - 1 - i, size);
      rows.insert(0, row);
      rows.add(row);
    }
    return rows;
  }
}
