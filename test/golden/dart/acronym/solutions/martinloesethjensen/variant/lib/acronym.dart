class Acronym {
  String abbreviate(String s) => s
      .split(RegExp(r'[\s-_]'))
      .where((word) => word.isNotEmpty)
      .map((word) => word[1].toUpperCase())
      .join();
}
