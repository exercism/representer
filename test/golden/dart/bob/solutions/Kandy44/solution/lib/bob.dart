class Bob {
bool isUpper(String s) {
  s = s.replaceAllMapped(RegExp(r'[^a-zA-Z]'), (match) {
    return '';
  });
  print(s);
  int upCount = 0;
  int alphaCount = 0;
  for (int i = 0; i < s.length; i++) {
    int asciiVal = s.codeUnitAt(i);
    if((asciiVal >= 65 && asciiVal <= 90) || (asciiVal >= 97 && asciiVal <= 122)) {
      ++alphaCount;
    }
    if (asciiVal >= 65 && asciiVal <= 90) {
      ++upCount;
    }
  }
  return upCount > 0 && upCount == alphaCount;
}
  String response(String hey_bob) {
    hey_bob = hey_bob.trim();
    if(hey_bob == "") {
      return "Fine. Be that way!";
    } else if(isUpper(hey_bob)) {
      if(hey_bob.endsWith("?")) {
        return "Calm down, I know what I'm doing!";
      } else {
        return "Whoa, chill out!";
      }
    } else if(hey_bob.endsWith("?")) {
      return "Sure.";
    } else {
      return "Whatever.";
    }
  }
}
