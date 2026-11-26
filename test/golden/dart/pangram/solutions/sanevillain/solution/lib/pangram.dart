class Pangram {
  // Put your code here
  bool isPangram(String string) =>
      string
          .toLowerCase()
          .replaceAll(new RegExp(r"[^a-z]"), "")
          .split("")
          .toSet()
          .length ==
      26;
}
