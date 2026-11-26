class Diamond {
    final int ASCII_DEC_A = 'A'.codeUnitAt(0);
    final int ASCII_DEC_Z = 'Z'.codeUnitAt(0);
    final int ASCII_DEC_SP = ' '.codeUnitAt(0);

    List<String> rows(String letter) {
        if (letter.length != 1) {
            return [];
        }

        letter = letter.toUpperCase();

        if (letter == "A") {
            return ["A"];
        }
        
        int ascii_dec = letter.codeUnitAt(0);

        if (ascii_dec < ASCII_DEC_A || ascii_dec > ASCII_DEC_Z) {
            return [];
        }

        var initial = " " * (ascii_dec - ASCII_DEC_A) + String.fromCharCode(ASCII_DEC_A) + " " * (ascii_dec - ASCII_DEC_A);
        List<String> result = [initial];

        for (var i = 1; i < ascii_dec - ASCII_DEC_A + 1; i++) {
            result.add(" " * (ascii_dec - ASCII_DEC_A - i) + String.fromCharCode(ASCII_DEC_A + i) + " " * (2 * (i-1) + 1) + String.fromCharCode(ASCII_DEC_A + i) + " " * (ascii_dec - ASCII_DEC_A - i));
        }
        
        return result + result.sublist(0, result.length-1).reversed.toList();
    }
}