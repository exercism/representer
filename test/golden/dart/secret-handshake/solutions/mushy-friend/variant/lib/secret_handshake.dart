// Implementation 2
class SecretHandshake {
  List<String> commands(int number) {
    List<String> comms = [];
    //ANy number AND-ed with 1,2,4 or 8 will give you whether the bitwise representation
    //has a 1 at that position
    //Eg 9 = 1001
    //1001 & 0001(1) = 0001 (1), 1001 & 0010(2) = 0, 1001 & 0100(4) = 0, 1001 & 1000(8) = 1000 (8)
    if (number & 1 == 1) comms.add("wink");
    if (number & 2 == 2) comms.add("double blink");
    if (number & 4 == 4) comms.add("close your eyes");
    if (number & 8 != 8) comms.add("jump");
    if (number & 16 == 16) comms = comms.reversed.toList();
    return comms;
  }
}

/* Implementation 1

class SecretHandshake {
  String binaryString = "";
  Map<int, String> handshakes = {
    0: 'wink',
    1: 'double blink',
    2: 'close your eyes',
    3: 'jump'
  };

  String _convertToBinary(int num) {
    StringBuffer buf = StringBuffer();
    while (num > 0) {
      buf.write(num % 2);
      num = num ~/ 2;
    }
    return buf.toString();
  }

  List<String> commands(int number) {
    binaryString = _convertToBinary(number);
    List<String> commands = [];
    for (int i = 0; i < binaryString.length; i++) {
      if (binaryString[i] == 1.toString() && i < 4) {
        commands.add(handshakes[i]!);
      }
    }
    if (binaryString.length > 4 && binaryString[4] == 1.toString()) {
      return commands.reversed.toList();
    }
    return commands;
  }
}
*/
