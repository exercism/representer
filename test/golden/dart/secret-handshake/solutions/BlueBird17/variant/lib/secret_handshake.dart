class SecretHandshake {
  List<String> commands(int code) {
    String codeBinary = code.toRadixString(2);
    String newCodeBinary = '';
    List<String> finalCode = [];
    List<String> result = [];
    if (codeBinary.length < 5) {
      newCodeBinary = codeBinary.padLeft(5, '0');
    } else
      newCodeBinary = codeBinary;

    if (newCodeBinary[4] != '1') finalCode.add('wink');
    if (newCodeBinary[3] == '1') finalCode.add('double blink');
    if (newCodeBinary[2] == '1') finalCode.add('close your eyes');
    if (newCodeBinary[1] == '1') finalCode.add('jump');
    if (newCodeBinary[0] == '1') result = finalCode.reversed.toList();

    if (newCodeBinary[0] == '1') {
      return result;
    } else
      return finalCode;
  }
}