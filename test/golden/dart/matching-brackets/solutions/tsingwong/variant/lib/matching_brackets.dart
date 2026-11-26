class MatchingBrackets {
  Map<String, String>map = {
    "]": "[",
    "}": "{",
    ")": "("
  };
  // Put your code here
  bool isPaired(String input) {
    var stack = <String>[];
    for (var curr in input.replaceAll(RegExp(r'[^\[\]\(\)\{\}]'), '').split("")) {
      print(stack);
      print(curr);
      if (!map.keys.contains(curr)) {
        stack.add(curr);
      } else {
        if (stack.isNotEmpty && (stack.last != map[curr])) {
          stack.removeLast();
        } else {
          return false;
        }
      }
    };
    return stack.isEmpty;
  }
}