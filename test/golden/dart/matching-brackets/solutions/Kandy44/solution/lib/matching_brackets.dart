class MatchingBrackets {
  bool isPaired(String inputStr) {
    List<String> s = [];
    for(int i = 0 ; i < inputStr.length; i++) {
      String cur = inputStr[i];
      if("([{".contains(cur)) {
        s.add(inputStr[i]);
      } else if(")]}".contains(cur)) {
        if(s.length < 1) {
          return false;
        }
        String topElem = s.removeLast();
        if((topElem == '(' && cur != ')') || (topElem == '[' && cur != ']') || (topElem == '{' && cur != '}')) {
          return false;
        }
      }
    }
    if(s.length != 0) {
      return false;
    }
    return true;
  }
}
