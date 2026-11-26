class Diamond {
  List<String> rows(String s) {
    final start = "A".codeUnitAt(0);
    final letterCount = s.codeUnitAt(0) - start + 1;

    final linesUpToLetter = List.generate(letterCount,
        (i) => _buildRow(String.fromCharCode(start + i), letterCount, i + 1));

    return [...linesUpToLetter, ...linesUpToLetter.reversed.skip(1)];
  }

  String _buildRow(String letter, int letterCount, int rowNumber) {
    final prePadding = ' ' * (letterCount - rowNumber);
    final postPadding = ' ' * (letterCount - prePadding.length - 1);

    final upToFirstLetter = "$prePadding$letter$postPadding";
    final afterFirstLetter = upToFirstLetter.split('').reversed.skip(1).join();

    return "$upToFirstLetter$afterFirstLetter";
  }
}
