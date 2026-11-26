
// Put your code here
bool isValid(String isbn) {
  RegExp isbnCheck = RegExp(r'^\d-{0,1}\d{3}-{0,1}\d{5}-{0,1}(?:\d|X)$');
  List<String> chars = isbn.split('');
  if (!isbnCheck.hasMatch(isbn)) {
    return false;
  }
  List<int> ds = chars
      .where((u) {
        if (u != '-') {
          return true;
        }
        return false;
      })
      .map((e) => e == 'X' ? 10 : int.parse(e))
      .toList();
  int d1 = ds[0] * 10;
  int d2 = ds[1] * 9;
  int d3 = ds[2] * 8;
  int d4 = ds[3] * 7;
  int d5 = ds[4] * 6;
  int d6 = ds[5] * 5;
  int d7 = ds[6] * 4;
  int d8 = ds[7] * 3;
  int d9 = ds[8] * 2;
  int d10 = ds[9] * 1;

  int result = (d1 + d2 + d3 + d4 + d5 + d6 + d7 + d8 + d9 + d10) % 11;
  return result == 0;
}