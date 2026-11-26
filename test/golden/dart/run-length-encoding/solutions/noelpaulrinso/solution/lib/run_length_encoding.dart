class RunLengthEncoder {
  String encode(String input) {
    var list = <String>[];
    String current = '';
    int n = 1;
    for (int i = 0; i < input.length; i++) {
      String next = input[i];
      if (next == current) {
        n++;
      } else {
        list.add(n > 1 ? '$n$current' : current);
        n = 1;
      }
      current = next;
    }
    list.add(n > 1 ? '$n$current' : current);
    return list.join();
  }

  String decode(String input) => RegExp(r'(?<n>\d*)(?<s>\D)')
      .allMatches(input)
      .map((x) => x.namedGroup('s')! * toInt(x.namedGroup('n')!))
      .join();

  int toInt(String s) => s.isEmpty ? 1 : int.parse(s);
}