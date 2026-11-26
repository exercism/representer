class Isogram {
  bool isIsogram(String inp) {
    var str = inp.replaceAll(' ', '').replaceAll('-', '');
    var set = Set.of(str.toLowerCase().split(''));
    return str.length == set.length;
  }
}
