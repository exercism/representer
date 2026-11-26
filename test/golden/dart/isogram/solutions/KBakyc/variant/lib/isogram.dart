class Isogram {
  bool isIsogram(String inp) {
    var str = inp.replaceAll(' ', '').replaceAll('-', '');
    var set = Set.of(str.toUpperCase().split(''));
    return str.length == set.length;
  }
}
