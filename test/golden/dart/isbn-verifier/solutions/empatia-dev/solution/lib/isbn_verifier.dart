bool isValid(String s) {
  s = s.replaceAll('-', '');
  if (!RegExp(r'^\d{9}[\dX]$').hasMatch(s)) return false;
  
  int weight = 10;
  final c = s
      .split('')
      .map((e) => e == 'X' ? 10 : int.parse(e))
      .fold(0, (sum, n) => sum + n * weight--);
  
  return c % 11 == 0;
}