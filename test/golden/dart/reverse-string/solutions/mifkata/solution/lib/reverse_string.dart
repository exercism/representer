String reverse(String str) {
  String b = '';
  for(int i = str.length - 1; i > -1; i--) {
    b += str[i];
  }

  return b;
}
